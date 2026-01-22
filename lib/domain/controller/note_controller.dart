import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hourlynotes/domain/note.dart';           // your Note model (update to include lastModified)
import 'package:hourlynotes/data/drive_backup_service.dart'; // the service you provided
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart'; // add this package: flutter pub add workmanager

// Background task name
const String syncTaskName = 'note-sync-background';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Init Hive (need to initFlutter for background)
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter()); // assuming you have the adapter

    final ctrl = NoteController(); // create temp instance for background
    await ctrl._initHive();
    await ctrl._loadNotesFromLocal();
    await ctrl.syncAllNotesToDrive(); // upload local to Drive
    await ctrl.restoreFromDrive();    // download & resolve conflicts

    return Future.value(true);
  });
}

class NoteController extends GetxController {
  // ── Reactive state ───────────────────────────────────────────────────────────
  final RxList<Note> notes = <Note>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxString syncError = ''.obs;

  // Services
  late Box<Note> _noteBox;
  final DriveBackupService _driveService = DriveBackupService();

  static const String notesBoxName = 'notes';

  @override
  void onInit() async {
    super.onInit();
    await _initHive();
    await _loadNotesFromLocal();
    _setupBackgroundSync();
    // Optional: initial sync
    _syncWithDrive();
  }

  Future<void> _initHive() async {
    _noteBox = await Hive.openBox<Note>(notesBoxName);
  }

  Future<void> _loadNotesFromLocal() async {
    isLoading.value = true;
    try {
      notes.assignAll(_noteBox.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp))); // newest first
    } finally {
      isLoading.value = false;
    }
  }

  // ── Core CRUD Operations ────────────────────────────────────────────────────

  /// Create or update a note (local + optional Drive sync)
  Future<void> saveNote(Note note, {bool syncNow = true}) async {
    // Update lastModified
    final updatedNote = note.copyWith(lastModified: DateTime.now());

    // 1. Save/Update locally in Hive
    await _noteBox.put(updatedNote.id.toString(), updatedNote);

    // 2. Update reactive list
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      notes.refresh();
    } else {
      notes.insert(0, updatedNote); // newest first
    }

    // 3. Sync to Drive if requested
    if (syncNow) {
      _syncNoteToDrive(updatedNote);
    }
  }

  /// Create a new note (generates ID automatically)
  Future<Note> createNote({
    required String text,
    Uint8List? imageBytes,
    String? localImagePath,
  }) async {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch; // or use uuid.v4() if preferred

    Note newNote = Note(
      id: id,
      text: text,
      timestamp: now,
      lastModified: now, // new field
      localImagePath: localImagePath,
      driveImageFileId: null,
    );

    if (imageBytes != null) {
      // Save image locally first → then we'll upload to Drive during sync
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/note_images');
      if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

      final fileName = 'note_${id}_${const Uuid().v4().substring(0, 8)}.png';
      final localPath = '${imagesDir.path}/$fileName';

      final file = File(localPath);
      await file.writeAsBytes(imageBytes);

      newNote = newNote.copyWith(localImagePath: localPath);
    }

    await saveNote(newNote);
    return newNote;
  }

  Future<void> updateNote(Note updatedNote) async {
    await saveNote(updatedNote);
  }

  Future<void> deleteNote(int noteId) async {
    // 1. Remove from Hive
    await _noteBox.delete(noteId.toString());

    // 2. Remove from reactive list
    notes.removeWhere((n) => n.id == noteId);
    notes.refresh();

    // 3. Delete from Drive (background)
    _deleteNoteFromDrive(noteId);
  }

  // ── Sync / Backup Functions ─────────────────────────────────────────────────

  /// Sync one note to Drive (called after local save)
  Future<void> _syncNoteToDrive(Note note) async {
    isSyncing.value = true;
    syncError.value = '';

    try {
      await _driveService.withAuth(() async {
        final driveFileId = await _driveService.saveNoteWithImage(note);
        // Optional: update local note with drive file ID if needed
      });
    } catch (e) {
      syncError.value = 'Sync failed: $e';
      print('Drive sync error for note ${note.id}: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> syncAllNotesToDrive() async {
    isSyncing.value = true;
    syncError.value = '';

    try {
      for (final note in notes) {
        await _syncNoteToDrive(note);
      }
    } catch (e) {
      syncError.value = 'Full sync failed: $e';
    } finally {
      isSyncing.value = false;
    }
  }

  /// Download & restore notes from Drive → Hive with conflict resolution
  Future<void> restoreFromDrive() async {
    isLoading.value = true;
    isSyncing.value = true;
    syncError.value = '';

    try {
      final remoteNotes = await _driveService.withAuth(() async {
        return await _driveService.downloadAndRestoreNotes();
      });

      // Conflict resolution
      for (final remote in remoteNotes) {
        final local = _noteBox.get(remote.id.toString());

        if (local == null) {
          // New from remote → add
          await saveNote(remote, syncNow: false);
        } else {
          // Conflict: compare lastModified (assume Note has this field now)
          if (remote.lastModified.isAfter(local.lastModified)) {
            // Remote newer → overwrite local
            await saveNote(remote, syncNow: false);
          } else if (local.lastModified.isAfter(remote.lastModified)) {
            // Local newer → upload local to Drive
            await _syncNoteToDrive(local);
          } else {
            // Same → maybe merge text or skip
            // For simplicity: skip
          }
        }
      }

      // Reload local after resolution
      await _loadNotesFromLocal();

      Get.snackbar('Success', 'Notes synced with Google Drive');
    } catch (e) {
      syncError.value = 'Restore failed: $e';
      Get.snackbar('Error', 'Failed to sync notes: $e');
    } finally {
      isLoading.value = false;
      isSyncing.value = false;
    }
  }

  /// Full bi-directional sync (upload local changes + download & resolve)
  Future<void> _syncWithDrive() async {
    await syncAllNotesToDrive();
    await restoreFromDrive();
  }

  /// Delete note from both local and Drive
  Future<void> _deleteNoteFromDrive(int noteId) async {
    try {
      await _driveService.withAuth(() async {
        await _driveService.deleteNoteAndImage(noteId);
      });
    } catch (e) {
      print('Failed to delete note $noteId from Drive: $e');
    }
  }

  // ── Background Sync Setup ───────────────────────────────────────────────────

  void _setupBackgroundSync() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // set to true for debug logs
    );

    // Register periodic task (e.g., every 15 min)
    Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: const Duration(minutes: 15), // min 15 min for iOS/Android
      constraints: Constraints(
        networkType: NetworkType.connected, // only when online
        requiresBatteryNotLow: true,
        requiresStorageNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<void> clearAllLocalNotes() async {
    await _noteBox.clear();
    notes.clear();
  }

  int get notesCount => notes.length;

  List<Note> getNotesByDate(DateTime date) {
    return notes.where((note) {
      return note.timestamp.year == date.year &&
             note.timestamp.month == date.month &&
             note.timestamp.day == date.day;
    }).toList();
  }

  @override
  void onClose() {
    _noteBox.close();
    super.onClose();
  }
}