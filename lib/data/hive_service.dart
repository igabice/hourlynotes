import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _settingsBoxName = 'settings';

  // Private constructor
  HiveService._();

  // Singleton instance
  static final HiveService _instance = HiveService._();

  // Getter for the instance
  static HiveService get instance => _instance;

  late Box _settingsBox;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // First Run
  bool isFirstRun() {
    return _settingsBox.get('firstRun', defaultValue: true);
  }

  Future<void> setFirstRun(bool value) async {
    await _settingsBox.put('firstRun', value);
  }

  // Active Theme
  String getActiveTheme() {
    return _settingsBox.get('activeTheme', defaultValue: 'system');
  }

  Future<void> setActiveTheme(String theme) async {
    await _settingsBox.put('activeTheme', theme);
  }

  // FCM Token
  String? getFcmToken() {
    return _settingsBox.get('fcmToken');
  }

  Future<void> saveFcmToken(String token) async {
    await _settingsBox.put('fcmToken', token);
  }
}
