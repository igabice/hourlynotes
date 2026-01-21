import 'package:google_sign_in/google_sign_in.dart';
import 'package:hourlynotes/data/hive_service.dart';
import 'package:hourlynotes/domain/models/user_models.dart';

import 'google_drive_service.dart'; // ← Import your previous service

/// Handles Google authentication flow for the app.
/// Uses DriveBackupService under the hood for actual sign-in/out.
class AuthService {
  final DriveBackupService _driveService;
  final HiveService _hiveService = HiveService.instance;

  AuthService({DriveBackupService? driveService})
      : _driveService = driveService ?? DriveBackupService();

  /// Checks if the user is currently signed in with Google.
  Future<bool> isLoggedIn() async {
    return await _driveService.isSignedIn();
  }

  /// Gets the currently signed-in Google account (null if not logged in).
  Future<GoogleSignInAccount?> getCurrentUser() async {
    return await _driveService.getCurrentUser();
  }

  /// Initiates Google Sign-In.
  /// Returns the signed-in account on success, throws on failure.
  /// Also ensures the app folder is ready after sign-in.
  Future<GoogleSignInAccount> signIn() async {
    try {
      final account = await _driveService.signIn();
      final userBox = await _hiveService.getBox(HiveService.userSettingsBox);
      var user = User(email: account.email, displayName: account.displayName!, photoUrl: account.photoUrl!);
      await userBox.put(USER_KEY, user.toJson());
      return account;
    } catch (e) {
      // You can re-throw with more context or handle specific errors
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Signs the user out.
  /// Clears any cached folder ID as well.
  Future<void> signOut() async {
    try {
      await _driveService.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Optional: convenience method to get user email/display name
  Future<String?> getUserEmail() async {
    final user = await getCurrentUser();
    return user?.email;
  }

  Future<String?> getUserDisplayName() async {
    final user = await getCurrentUser();
    return user?.displayName;
  }
}