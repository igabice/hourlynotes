import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourlynotes/data/google_drive_service.dart';


import '../../data/hive_service.dart';
import '../../presentation/home_screen.dart';
import '../models/user_models.dart';

class AccountController extends GetxController {
  final DriveBackupService _driveService = DriveBackupService();
  final HiveService _db = HiveService.instance;

  // Reactive state
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFirstRun = true.obs;

  // Form controllers & keys
  final usernameKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;

    // 1. Check first run
    isFirstRun.value = await _db.isFirstAppRun();

    // 2. Load cached user
    await loadUserFromStorage();

    isLoading.value = false;
  }

  Future<bool> isLoggedIn() async {
    return await _driveService.isSignedIn();
  }

  /// Gets the currently signed-in Google account (null if not logged in).
  Future<void> getCurrentUser() async {
    var account = await _driveService.getCurrentUser();
    var currentUser = User(email: account!.email, displayName: account.displayName!, photoUrl: account.photoUrl!);
    user.value = currentUser;
  }

  Future<void> loadUserFromStorage() async {
    final cachedUser = await _db.getUser();
    if (cachedUser != null) {
      user.value = cachedUser;
      // Optional: fill controllers if needed for editing profile
      firstNameController.text = cachedUser.displayName;
      emailController.text = cachedUser.email;
    } else {
      user.value = null;
    }
  }

  Future<void> saveUserToStorage() async {
    if (user.value == null) return;
    await _db.saveUser(user.value!);
  }

  /// Call this after successful login / signup
  Future<void> setAndSaveUser(User newUser) async {
    user.value = newUser;
    await _db.saveUser(newUser);

    // If this was first run → mark as opened
    if (isFirstRun.value) {
      await _db.markAppAsOpened();
      isFirstRun.value = false;
    }
  }

  Future<void> signIn() async {
    try {
      final account = await _driveService.signIn();
      var loggedUser = User(
        email: account.email,
        displayName: account.displayName ?? account.email.split('@').first,
        photoUrl: account.photoUrl ?? '',
      );
      user.value = loggedUser;

      await _db.saveUser(loggedUser);

      Get.to(()=> const HomeScreen());
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    try {
      // 1. Sign out from auth (firebase, etc.)
      await _driveService.signOut();

      // 2. Clear local storage
      await _db.logoutAndClear();

      // 3. Reset state
      user.value = null;
      isFirstRun.value = await _db.isFirstAppRun();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}