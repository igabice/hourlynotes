import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hourlynotes/data/controllers/note_controller.dart'; // adjust path

class AddNoteController extends GetxController {
  // ── Observable state ───────────────────────────────────────────────────────
  final noteText = ''.obs;
  final selectedCategory = 'work'.obs;
  final selectedImage = Rxn<File>();
  final imageBytes = Rxn<Uint8List>();

  // Fixed times (can be made editable later)
  final startTime = Rxn<DateTime>();
  final endTime = Rxn<DateTime>();

  final ImagePicker _picker = ImagePicker();
  final NoteController _noteController = Get.find<NoteController>();

  @override
  void onInit() {
    super.onInit();
    _initializeTimes();
  }

  void _initializeTimes() {
    final now = DateTime.now();
    startTime.value = DateTime(now.year, now.month, now.day, now.hour, 0);
    endTime.value = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
  }

  Duration get sessionDuration => endTime.value!.difference(startTime.value!);

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (file != null) {
        final bytes = await file.readAsBytes();
        selectedImage.value = File(file.path);
        imageBytes.value = bytes;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeImage() {
    selectedImage.value = null;
    imageBytes.value = null;
  }

  Future<void> saveNote() async {
    final text = noteText.value.trim();
    if (text.isEmpty) {
      Get.snackbar('Required', 'Please write something...',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await _noteController.createNote(
        text: text,
        imageBytes: imageBytes.value,
      );

      Get.back(); // close screen
      Get.snackbar(
        'Success',
        'Note saved successfully!',
        backgroundColor: const Color(0xFF00838F),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to save note: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Optional: if you later want to allow changing times
  void updateStartTime(DateTime newTime) {
    startTime.value = newTime;
  }

  void updateEndTime(DateTime newTime) {
    endTime.value = newTime;
  }
}