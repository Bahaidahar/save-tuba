import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(80, 121, 65, 1);
  static const Color secondary = Color.fromRGBO(47, 95, 43, 1);

  // static const Color lightGreen = Color(0xFF66BB6A);
  // static const Color darkGreen = Color(0xFF1B5E20);
  // static const Color beige = Color(0xFFF5F5DC);
  // static const Color lightBeige = Color(0xFFFAF8F3);
  // static const Color darkBeige = Color(0xFFD4C5A9);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: primary,
      fontFamily: 'InstrumentSans',
    );
  }

  // static ThemeData get lightTheme {
  //   return ThemeData(
  //     primarySwatch: createMaterialColor(primaryGreen),
  //     primaryColor: primaryGreen,
  //     scaffoldBackgroundColor: lightBeige,
  //     colorScheme: const ColorScheme.light(
  //       primary: primaryGreen,
  //       onPrimary: Colors.white,
  //       secondary: beige,
  //       onSecondary: primaryGreen,
  //       surface: Colors.white,
  //       onSurface: Colors.black87,
  //       background: lightBeige,
  //       onBackground: Colors.black87,
  //     ),
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: primaryGreen,
  //       foregroundColor: Colors.white,
  //       elevation: 0,
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: primaryGreen,
  //         foregroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
  //       ),
  //     ),
  //     outlinedButtonTheme: OutlinedButtonThemeData(
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: primaryGreen,
  //         side: const BorderSide(color: primaryGreen),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
  //       ),
  //     ),
  //     textTheme: const TextTheme(
  //       headlineLarge: TextStyle(
  //         color: primaryGreen,
  //         fontSize: 32,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       headlineMedium: TextStyle(
  //         color: primaryGreen,
  //         fontSize: 24,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       bodyLarge: TextStyle(
  //         color: Colors.black87,
  //         fontSize: 16,
  //       ),
  //       bodyMedium: TextStyle(
  //         color: Colors.black54,
  //         fontSize: 14,
  //       ),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: Colors.white,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.grey),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.grey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: primaryGreen, width: 2),
  //       ),
  //       contentPadding:
  //           const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //     ),
  //   );
  // }

  // static MaterialColor createMaterialColor(Color color) {
  //   List strengths = <double>[.05];
  //   Map<int, Color> swatch = {};
  //   final int r = color.red, g = color.green, b = color.blue;

  //   for (int i = 1; i < 10; i++) {
  //     strengths.add(0.1 * i);
  //   }
  //   for (var strength in strengths) {
  //     final double ds = 0.5 - strength;
  //     swatch[(strength * 1000).round()] = Color.fromRGBO(
  //       r + ((ds < 0 ? r : (255 - r)) * ds).round(),
  //       g + ((ds < 0 ? g : (255 - g)) * ds).round(),
  //       b + ((ds < 0 ? b : (255 - b)) * ds).round(),
  //       1,
  //     );
  //   }
  //   return MaterialColor(color.value, swatch);
  // }

  // Helper method for styled modal bottom sheets
}
