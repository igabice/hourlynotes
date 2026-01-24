import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hourlynotes/data/hive_service.dart';
import 'package:hourlynotes/data/notification_service.dart';
import 'package:hourlynotes/domain/controller/user_settings_controller.dart';
import 'package:hourlynotes/domain/user_settings_repository.dart';
import 'package:hourlynotes/infrastructure/hive_user_settings_repository.dart';
import 'package:provider/provider.dart';

import 'package:hourlynotes/presentation/theme_provider.dart';
import 'package:hourlynotes/presentation/themes.dart';
import 'package:hourlynotes/presentation/login_screen.dart';
import 'domain/controller/account_controller.dart';
import 'domain/controller/add_note_controller.dart';
import 'domain/controller/note_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveService.instance.init();
  await NotificationService().init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    Get.put(NoteController());
    Get.put(AddNoteController());
    Get.put<UserSettingsRepository>(HiveUserSettingsRepository());
    Get.put(UserSettingsController(Get.find()));

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          title: 'Hourly Note',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const LoginScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}