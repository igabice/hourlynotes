import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hourlynotes/domain/note.dart';
import 'package:i_google_drive/i_google_drive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // optional

/// High-level service for app-specific Google Drive operations
/// (notes & images backup/sync in a dedicated folder).
class DriveBackupService {  // ← Renamed to avoid conflict!
  static const String _appFolderName = 'MobCryptoNotes';

  // Real instance from the package
  final GoogleDriveService _drive = GoogleDriveService(
    scopes: [
      'https://www.googleapis.com/auth/drive.file', // minimal scope recommended
      // 'https://www.googleapis.com/auth/drive' if you need broader access
    ],
  );

  String? _appFolderId;

  Future<bool> isSignedIn() => _drive.isSignedIn();

  Future<GoogleSignInAccount?> getCurrentUser() => _drive.getCurrentUser();

  Future<GoogleSignInAccount> signIn() async {
    final account = await _drive.signIn();
    await _ensureAppFolder();
    return account;
  }

  Future<void> signOut() async {
    await _drive.signOut();
    _appFolderId = null;
  }

  Future<String> _ensureAppFolder() async {
    if (_appFolderId != null) return _appFolderId!;

    // Search in root (no parent = root)
    final existing = await _drive.listFiles(
      query: "mimeType='application/vnd.google-apps.folder' "
          "and name='$_appFolderName' "
          "and trashed=false",
    );

    if (existing.isNotEmpty) {
      _appFolderId = existing.first.id;
      return _appFolderId!;
    }

    // Create in root
    final folder = await _drive.createFolder(folderName: _appFolderName);
    _appFolderId = folder.id;
    return _appFolderId!;
  }

  Future<String> saveNote({
    required String noteId,
    required String content,
    String extension = 'json',
  }) async {
    final folderId = await _ensureAppFolder();
    final fileName = '$noteId.$extension';

    // Check for existing file by name in the folder
    final existing = await _drive.getFileByName(
      fileName,
      folderId: folderId,
    );

    // Prepare temp file (uploadFile needs File)
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File(p.join(tempDir.path, fileName));
    await tempFile.writeAsString(content);

    try {
      final result = await _drive.uploadFile(
        tempFile,
        fileName: fileName,
        folderId: folderId,
        overwrite: existing != null,
      );

      if (!result.success || result.file?.id == null) {
        throw Exception(result.error ?? 'Upload failed');
      }

      return result.file!.id;
    } finally {
      tempFile.deleteSync();
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<Map<String, String>> getNotes() async {
    final folderId = await _ensureAppFolder();

    final files = await _drive.listFiles(
      folderId: folderId,
      query: "mimeType='application/json' and trashed=false",
    );

    final Map<String, String> notes = {};

    for (final file in files) {
      final id = file.id;
      final name = file.name;
      if (id == null || name == null || !name.endsWith('.json')) continue;

      try {
        final localFile = await _drive.downloadFile(id);
        final content = await localFile.readAsString();
        final noteId = p.basenameWithoutExtension(name);
        notes[noteId] = content;
        localFile.deleteSync(); // cleanup
      } catch (e) {
        print('Download failed for $name: $e');
      }
    }

    return notes;
  }

  Future<void> deleteNote(String noteId) async {
    final folderId = await _ensureAppFolder();
    final fileName = '$noteId.json';

    final file = await _drive.getFileByName(fileName, folderId: folderId);
    if (file != null && file.id != null) {
      await _drive.deleteFile(file.id!);
    }
  }

  Future<String> saveImage({
    required Uint8List bytes,
    String? imageId,
    String extension = 'png',
    String mimeType = 'image/png',
  }) async {
    final folderId = await _ensureAppFolder();
    final name = imageId ?? const Uuid().v4();
    final fileName = '$name.$extension';

    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File(p.join(tempDir.path, fileName));
    await tempFile.writeAsBytes(bytes);

    try {
      final result = await _drive.uploadFile(
        tempFile,
        fileName: fileName,
        folderId: folderId,
        overwrite: true,
      );

      if (!result.success || result.file?.id == null) {
        throw Exception(result.error ?? 'Image upload failed');
      }

      return result.file!.id;
    } finally {
      tempFile.deleteSync();
      tempDir.deleteSync(recursive: true);
    }
  }

/// Saves a complete Note (text + optional image) to Google Drive.
/// - Uploads note metadata as JSON
/// - If note has localImagePath and no driveImageFileId yet → uploads the image and stores its Drive ID
/// - Returns the Drive file ID of the note JSON file
Future<String> saveNoteWithImage(Note note) async {
  final folderId = await _ensureAppFolder();
  final noteFileName = 'note_${note.id}.json';

  // 1. Prepare note JSON (including driveImageFileId if already set)
  String jsonContent = jsonEncode(note.toJson());

  // 2. If there's a local image path and no Drive ID yet → upload image
  String? newDriveImageId;

  if (note.localImagePath != null &&
      (note.driveImageFileId == null || note.driveImageFileId!.isEmpty)) {
    
    final imageFile = File(note.localImagePath!);
    if (await imageFile.exists()) {
      try {
        final extension = p.extension(note.localImagePath!).replaceFirst('.', '');
        final mimeType = _getMimeTypeFromExtension(extension);

        final uploadResult = await _drive.uploadFile(
          imageFile,
          fileName: 'note_image_${note.id}.$extension',
          folderId: folderId,
          overwrite: true, // replace if same name already exists
        );

        if (!uploadResult.success || uploadResult.file?.id == null) {
          throw Exception('Image upload failed: ${uploadResult.error ?? "Unknown error"}');
        }

        newDriveImageId = uploadResult.file!.id;

        // Update note model with new Drive ID
        final updatedNote = note.copyWith(driveImageFileId: newDriveImageId);

        // Re-encode JSON with the new image ID
        jsonContent = jsonEncode(updatedNote.toJson());

      } catch (e) {
        print('Image upload failed for note ${note.id}: $e');
        // Proceed to save note text anyway (partial success)
      }
    } else {
      print('Local image file not found: ${note.localImagePath}');
    }
  }

  // 3. Check for existing note JSON file
  final existing = await _drive.getFileByName(
    noteFileName,
    folderId: folderId,
  );

  // 4. Write JSON to temp file and upload
  final tempDir = await Directory.systemTemp.createTemp();
  final tempFile = File(p.join(tempDir.path, noteFileName));
  await tempFile.writeAsString(jsonContent);

  try {
    final uploadResult = await _drive.uploadFile(
      tempFile,
      fileName: noteFileName,
      folderId: folderId,
      overwrite: existing != null,
    );

    if (!uploadResult.success || uploadResult.file?.id == null) {
      throw Exception('Note JSON upload failed: ${uploadResult.error ?? "Unknown"}');
    }

    return uploadResult.file!.id;
  } finally {
    // Cleanup temp files
    await tempFile.delete();
    await tempDir.delete(recursive: true);
  }
}

/// Simple mime type helper (expand as needed)
String _getMimeTypeFromExtension(String ext) {
  final lower = ext.toLowerCase();
  if (lower == 'jpg' || lower == 'jpeg') return 'image/jpeg';
  if (lower == 'png') return 'image/png';
  if (lower == 'webp') return 'image/webp';
  if (lower == 'gif') return 'image/gif';
  return 'application/octet-stream'; // fallback
}
  Future<Uint8List> getImage(String fileId) async {
    final localFile = await _drive.downloadFile(fileId);
    try {
      return await localFile.readAsBytes();
    } finally {
      localFile.deleteSync();
    }
  }

  Future<void> deleteImage(String fileId) => _drive.deleteFile(fileId);

  Future<bool> ensureAuthenticated({bool promptUser = true}) async {
  if (await isSignedIn()) {
    return true; // Already good
  }

  try {
    // Try silent re-auth first (no UI prompt)
    // Note: google_sign_in has signInSilently(), but i_google_drive doesn't expose it directly.
    // Fallback: call signIn() — on mobile it often re-uses credentials silently if possible.
    await signIn(); // This may show UI if silent isn't possible
    return true;
  } catch (e) {
    if (promptUser) {
      // Already prompted via signIn() — just re-throw or log
      print('Re-auth prompt shown, but failed: $e');
    } else {
      print('Silent re-auth failed: $e');
    }
    return false;
  }
}

Future<T> withAuth<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } catch (e) {
    // Check if error is auth-related (common codes/strings)
    final isAuthError = e.toString().contains('authentication') ||
        e.toString().contains('sign') ||
        e.toString().contains('token') ||
        e.toString().contains('401') ||   // Unauthorized
        e.toString().contains('403');     // Forbidden / revoked

    if (isAuthError) {
      final reAuthed = await ensureAuthenticated(promptUser: true);
      if (reAuthed) {
        // Retry once after re-auth
        return await operation();
      } else {
        throw Exception('Authentication required. Please sign in again.');
      }
    }
    rethrow; // Other errors (network, quota, etc.)
  }
}

Future<String> saveNoteWithImageFromBytes(Note note, Uint8List? imageBytes) async {
  String? tempImagePath;

  if (imageBytes != null && (note.driveImageFileId == null || note.driveImageFileId!.isEmpty)) {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempImageFile = File(p.join(tempDir.path, 'note_image_${note.id}.png'));
    await tempImageFile.writeAsBytes(imageBytes);
    tempImagePath = tempImageFile.path;

    // Temporarily set local path for the upload logic
    note = Note(
      id: note.id,
      text: note.text,
      timestamp: note.timestamp,
      localImagePath: tempImagePath,
      driveImageFileId: note.driveImageFileId,
      lastModified: null,
    );

    try {
      final noteId = await saveNoteWithImage(note); // now uses the temp file
      return noteId;
    } finally {
      await tempImageFile.delete();
      await tempDir.delete(recursive: true);
    }
  }

  // Fallback: no image → just save note text
  return saveNoteWithImage(note);
}

Future<List<Note>> downloadAndRestoreNotes() async {
    final folderId = await _ensureAppFolder();

    // Find all note JSON files
    final files = await _drive.listFiles(
      folderId: folderId,
      query: "name contains 'note_' and mimeType='application/json' and trashed=false",
    );

    final List<Note> restoredNotes = [];
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'note_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    for (final file in files) {
      if (file.id == null || file.name == null) continue;

      try {
        // Download note JSON
        final localJsonFile = await _drive.downloadFile(file.id!);
        final jsonString = await localJsonFile.readAsString();
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        var note = Note.fromJson(jsonMap);

        // If note has image on Drive → download and save locally
        if (note.driveImageFileId != null && note.driveImageFileId!.isNotEmpty) {
          try {
            final imageFile = await _drive.downloadFile(note.driveImageFileId!);
            final extension = p.extension(imageFile.path) ?? '.jpg';
            final localImagePath = p.join(
              imagesDir.path,
              'note_${note.id}_image$extension',
            );

            await imageFile.copy(localImagePath);
            await imageFile.delete(); // cleanup Drive temp file

            // Update note with local path
            note = Note(
              id: note.id,
              text: note.text,
              timestamp: note.timestamp,
              localImagePath: localImagePath,
              driveImageFileId: note.driveImageFileId, lastModified: null,
            );
          } catch (imgErr) {
            print('Failed to download image for note ${note.id}: $imgErr');
            // Continue without image
          }
        }

        restoredNotes.add(note);

        // Cleanup JSON temp file
        await localJsonFile.delete();

      } catch (e) {
        print('Failed to process note file ${file.name}: $e');
      }
    }

    // Save/upsert to Hive
    await _saveNotesToHive(restoredNotes);

    return restoredNotes;
  }

  /// Helper: Save or update notes in Hive
  Future<void> _saveNotesToHive(List<Note> notes) async {
    final box = await Hive.openBox<Note>('notes');
    
    for (final note in notes) {
      await box.put(note.id.toString(), note);
    }
  }

  /// Optional: Delete a note from Drive + local storage
  Future<void> deleteNoteAndImage(int noteId) async {
    final folderId = await _ensureAppFolder();
    final noteFileName = 'note_$noteId.json';

    // Delete note JSON
    final noteFile = await _drive.getFileByName(noteFileName, folderId: folderId);
    if (noteFile?.id != null) {
      await _drive.deleteFile(noteFile!.id!);
    }

    // Delete image if exists (you'd need to know driveImageFileId)
    // → Ideally fetch from Hive first
    final box = await Hive.openBox<Note>('notes');
    final localNote = box.get(noteId.toString());
    if (localNote?.driveImageFileId != null) {
      await _drive.deleteFile(localNote!.driveImageFileId!);
    }

    // Delete local image file if exists
    if (localNote?.localImagePath != null) {
      final localImg = File(localNote!.localImagePath!);
      if (await localImg.exists()) await localImg.delete();
    }

    // Remove from Hive
    await box.delete(noteId.toString());
  }

}

// Instead of direct calls:
// final fileId = await withAuth(() => saveNote(noteId: '123', content: jsonEncode(note)));

// Or for getNotes, uploadImage, etc.
// final notes = await withAuth(() => getNotes());