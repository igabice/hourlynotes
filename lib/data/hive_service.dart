import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user_models.dart'; // adjust path if needed

class HiveService {
  static const String userSettingsBox = 'user_settings';

  static const String _userKey = 'current_user';
  static const String _isFirstRunKey = 'is_first_run';

  // Private constructor
  HiveService._();

  static final HiveService _instance = HiveService._();

  static HiveService get instance => _instance;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    // Register adapter if you haven't already
    // (you'll need to generate it with build_runner)
    // Hive.registerAdapter(UserAdapter());

    _isInitialized = true;
  }

  Future<Box> getSettingsBox() async {
    await init(); // make sure Hive is initialized
    if (!Hive.isBoxOpen(userSettingsBox)) {
      return await Hive.openBox(userSettingsBox);
    }
    return Hive.box(userSettingsBox);
  }

  // ── User methods ────────────────────────────────────────────────────────────

  Future<void> saveUser(User user) async {
    final box = await getSettingsBox();
    await box.put(_userKey, user.toJson());
  }

  Future<User?> getUser() async {
    final box = await getSettingsBox();
    final userJson = box.get(_userKey) as Map<dynamic, dynamic>?;

    if (userJson == null) return null;

    try {
      return User.fromJson(Map<String, dynamic>.from(userJson));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUser() async {
    final box = await getSettingsBox();
    await box.delete(_userKey);
  }

  // ── First run flag ──────────────────────────────────────────────────────────

  Future<bool> isFirstAppRun() async {
    final box = await getSettingsBox();
    // If key doesn't exist → first run (returns true)
    return box.get(_isFirstRunKey, defaultValue: true) as bool;
  }

  Future<void> markAppAsOpened() async {
    final box = await getSettingsBox();
    await box.put(_isFirstRunKey, false);
  }

  // ── Logout / clear all user-related data ───────────────────────────────────

  Future<void> logoutAndClear() async {
    final box = await getSettingsBox();
    await box.clear(); // or delete only specific keys if you store more later
    // await box.deleteAll([_userKey, _isFirstRunKey]); // alternative
  }
}