import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

var USER_KEY = 'users';

class HiveService {
  static const String userSettingsBox = 'user_settings';

  // Private constructor
  HiveService._();

  // Singleton instance
  static final HiveService _instance = HiveService._();

  // Getter for the instance
  static HiveService get instance => _instance;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
  }

  Future<Box<T>> getBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }
}

