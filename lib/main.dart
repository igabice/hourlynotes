import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hourlynotes/data/hive_service.dart';
import 'package:provider/provider.dart';

import 'package:hourlynotes/presentation/theme_provider.dart';
import 'package:hourlynotes/presentation/settings_provider.dart';
import 'package:hourlynotes/presentation/themes.dart';
import 'package:hourlynotes/presentation/login_screen.dart';
import 'package:hourlynotes/presentation/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveService.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
