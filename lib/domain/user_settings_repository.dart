import 'package:hourlynotes/domain/models/user_settings.dart';

abstract class UserSettingsRepository {
  Future<UserSettings> getUserSettings();
  Future<void> saveUserSettings(UserSettings settings);
  Future<void> deleteUserSettings();
}