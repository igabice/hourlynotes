import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:invoyse/presentation/features/controllers/app_controller.dart';

class InvoysesTheme {
  static ThemeData get theme {
    try {
      // final appController = Get.find<AppController>();
      return
        // appController.themeMode.value == ThemeMode.dark
        //   ? darkTheme
        //   :
        lightTheme;
    } catch (e) {
      // Fallback to light theme if AppController is not available
      debugPrint('AppController not found, using light theme as fallback: $e');
      return lightTheme;
    }
  }

  // Common Colors
  static Color primary = HexColor("#FFB600");
  static Color primaryAccent = const Color.fromRGBO(255, 182, 0, 0.2);
  static Color textColor = HexColor("#5B667A");
  static Color disabledColor = HexColor("#E4E4E4");
  static Color errorColor = const Color.fromRGBO(221, 0, 0, 1);
  static Color powderErrorColor = const Color.fromRGBO(255, 110, 110, 1);
  static Color successColor = HexColor("#1CE55F");
  static Color textBorderColor = const Color.fromRGBO(230, 230, 230, 1);

  // Light Theme Colors
  static Color lightBackground = Colors.white;
  static Color lightAppBarBackground = Colors.white;
  static Color lightScaffoldBackground = Colors.white;
  static Color lightCardBackground = Colors.white;
  static Color lightContainerBackground =
      HexColor("#FAF9F9"); // Added for light containers
  static Color lightIconColor = HexColor("#121212");
  static Color lightTextColor = HexColor("#202020");
  static Color lightLabelColor = const Color(0xFF5F5F5F);
  static Color lightSubLabelColor = const Color(0xFF707070);
  static Color lightButtonColor = primary;

  // Dark Theme Colors
  static Color darkBackground = HexColor("#121212");
  static Color darkAppBarBackground = HexColor("#121212");
  static Color darkAppBarBackgroundAccent = const Color.fromRGBO(32, 32, 32, 1);
  static Color darkScaffoldBackground = HexColor("#121212");
  static Color darkCardBackground = HexColor("#121212");
  static Color darkContainerBackground =
      HexColor("#292929"); // Added for dark containers
  static Color darkIconColor = const Color.fromARGB(255, 211, 211, 211);
  static Color darkTextColor = const Color.fromARGB(255, 211, 211, 211);
  static Color darkLabelColor = const Color.fromARGB(255, 211, 211, 211);
  static Color darkSubLabelColor = const Color.fromARGB(255, 211, 211, 211);
  static Color darkButtonColor = primary;
  static Color darkShade19 = const Color.fromRGBO(217, 217, 217, 0.19);

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: Colors.white,
          tertiary: lightIconColor,
          onTertiary: primary,
          surface:
              lightContainerBackground, // Changed from lightBackground to lightContainerBackground
          secondaryContainer: const Color(0x59E6E6E6),
          outline: Colors.white,
          outlineVariant: Colors.white,
          tertiaryContainer: lightIconColor,
          onSurface: lightButtonColor,
          onSurfaceVariant: Colors.black,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: lightScaffoldBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: lightAppBarBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: darkAppBarBackground),
          surfaceTintColor: Colors.transparent,
        ),
        cardColor: lightCardBackground,
        iconTheme: IconThemeData(color: lightTextColor),
        listTileTheme: ListTileThemeData(iconColor: darkAppBarBackground),
        textTheme: _buildTextTheme(
            lightTextColor, lightLabelColor, lightSubLabelColor),
        inputDecorationTheme: _buildInputDecorationTheme(darkAppBarBackground),
        elevatedButtonTheme: _buildElevatedButtonTheme(Colors.transparent),
        outlinedButtonTheme: _buildOutlinedButtonTheme(),
        dialogTheme: _buildDialogTheme(Colors.white),
        datePickerTheme: _buildDatePickerTheme(darkAppBarBackground),
        popupMenuTheme: PopupMenuThemeData(iconColor: lightTextColor));
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: primary,
        surface:
            darkContainerBackground, // Changed from darkBackground to darkContainerBackground
        onTertiary: darkBackground,
        tertiary: Colors.white,
        secondaryContainer: const Color(0x59E6E6E6),
        secondary: primary,
        outline: Colors.transparent,
        tertiaryContainer: primary,
        onSurface: darkButtonColor,
        onSurfaceVariant: Colors.white,
        onBackground: Colors.black,
      ),
      scaffoldBackgroundColor: darkScaffoldBackground,
      appBarTheme: AppBarTheme(
          backgroundColor: darkAppBarBackground,
          elevation: 0,
          surfaceTintColor: Colors.transparent),
      cardColor: darkCardBackground,
      iconTheme: IconThemeData(
        color: darkIconColor,
      ),
      primaryIconTheme: IconThemeData(
        color: darkIconColor,
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(darkIconColor))),
      listTileTheme: ListTileThemeData(iconColor: lightAppBarBackground),
      textTheme:
          _buildTextTheme(darkTextColor, darkLabelColor, darkSubLabelColor),
      inputDecorationTheme: _buildInputDecorationTheme(darkIconColor),
      elevatedButtonTheme: _buildElevatedButtonTheme(darkButtonColor),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      dialogTheme: _buildDialogTheme(darkAppBarBackground),
      datePickerTheme: _buildDatePickerTheme(lightAppBarBackground),
      popupMenuTheme: PopupMenuThemeData(iconColor: darkIconColor),
    );
  }

  static TextTheme _buildTextTheme(
      Color textColor, Color labelColor, Color subLabelColor) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 32,
          fontWeight: FontWeight.w400),
      displayMedium: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 28,
          fontWeight: FontWeight.w400),
      displaySmall: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 24,
          fontWeight: FontWeight.w400),

      // Headline styles
      headlineLarge: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 22,
          fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 20,
          fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 18,
          fontWeight: FontWeight.w400),

      // Title styles
      titleLarge: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 16,
          fontWeight: FontWeight.w400),
      titleMedium: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 14,
          fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 12,
          fontWeight: FontWeight.w500),

      // Body styles
      bodyLarge: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 16,
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 14,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          color: textColor,
          fontFamily: 'Figtree',
          fontSize: 12,
          fontWeight: FontWeight.w400),

      // Label styles
      labelLarge: TextStyle(
          color: labelColor,
          fontFamily: 'Figtree',
          fontSize: 14,
          fontWeight: FontWeight.w500),
      labelMedium: TextStyle(
          color: subLabelColor,
          fontFamily: 'Figtree',
          fontSize: 12,
          fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          color: subLabelColor,
          fontFamily: 'Figtree',
          fontSize: 10,
          fontWeight: FontWeight.w500),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(Color iconColor) {
    return InputDecorationTheme(
      iconColor: iconColor,
      prefixIconColor: iconColor,
      suffixIconColor: iconColor,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
      Color backgroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  static DialogThemeData? _buildDialogTheme(Color backgroundColor) {
    return DialogThemeData(
      backgroundColor: backgroundColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static DatePickerThemeData _buildDatePickerTheme(Color textColor) {
    return DatePickerThemeData(
      weekdayStyle: TextStyle(color: textColor),
      dayStyle: TextStyle(color: textColor),
      yearStyle: TextStyle(color: textColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: textColor),
        helperStyle: TextStyle(color: textColor),
      ),
      //dayBackgroundColor: WidgetStatePropertyAll(textColor),
      dayForegroundColor: WidgetStatePropertyAll(textColor),
      yearForegroundColor: WidgetStatePropertyAll(textColor),
      headerForegroundColor: textColor,
      yearOverlayColor: WidgetStatePropertyAll(textColor),
      rangePickerSurfaceTintColor: textColor,
      rangePickerHeaderBackgroundColor: textColor,
      rangePickerHeaderForegroundColor: textColor,
      rangeSelectionOverlayColor: WidgetStatePropertyAll(textColor),
      rangeSelectionBackgroundColor: textColor,

      //  yearBackgroundColor: WidgetStatePropertyAll(textColor),
      rangePickerHeaderHeadlineStyle: TextStyle(
        color: textColor,
      ),
      rangePickerHeaderHelpStyle: TextStyle(
        color: textColor,
      ),
      rangePickerBackgroundColor: textColor,

      confirmButtonStyle: ButtonStyle(
        surfaceTintColor: WidgetStatePropertyAll(textColor),
        foregroundColor: WidgetStatePropertyAll(textColor),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: textColor,
          ),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        surfaceTintColor: WidgetStatePropertyAll(textColor),
        foregroundColor: WidgetStatePropertyAll(textColor),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
