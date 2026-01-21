import 'package:hive/hive.dart';
import 'package:hourlynotes/data/hive_service.dart';
import 'package:hourlynotes/domain/models/user_settings.dart';

class UserSettingsRepository {
  final HiveService _hiveService;

  UserSettingsRepository(this._hiveService);

  Future<UserSettings> getUserSettings() async {
    final box = await _hiveService.getBox<Map<dynamic, dynamic>>(HiveService.userSettingsBox);
    final settingsMap = box.get('settings');
    if (settingsMap != null) {
      return UserSettings.fromJson(settingsMap.cast<String, dynamic>());
    }
    return UserSettings();
  }

  Future<void> saveUserSettings(UserSettings settings) async {
    final box = await _hiveService.getBox<Map<dynamic, dynamic>>(HiveService.userSettingsBox);
    await box.put('settings', settings.toJson());
  }
}
