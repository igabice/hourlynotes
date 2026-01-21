import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF00838F);
const Color lightBackground = Color(0xFFF5F7FA);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF7F9F9),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    background: const Color(0xFFF7F9F9),
    surface: Colors.white,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    headlineLarge: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    titleMedium: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black87),
    titleSmall: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
    bodyLarge: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
    bodyMedium: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black54),
    bodySmall: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
    labelLarge: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
    labelMedium: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
    labelSmall: GoogleFonts.openSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
  ).apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return null;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor.withOpacity(0.5);
      }
      return null;
    }),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  iconTheme: const IconThemeData(color: primaryColor),
  dividerColor: Colors.grey[200],
);


const Color darkPrimaryColor = Color(0xFF6A1B9A);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.lexend(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.normal),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
);
