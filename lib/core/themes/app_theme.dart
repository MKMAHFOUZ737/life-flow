import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paperBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.mochaText,
        secondary: AppColors.warmTanAccent,
        surface: AppColors.paperCard,
        error: AppColors.errorRust,
        onSurface: AppColors.mochaText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paperBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.mochaText,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: AppColors.mochaText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paperCard,
        elevation: 1,
        shadowColor: AppColors.outerBorder.withAlpha(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.mochaText,
        foregroundColor: AppColors.paperBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
    );
  }

  static ThemeData get darkTheme {
    // Elegant warm dark parchment variant
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1E1A17),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.warmTanAccent,
        secondary: AppColors.warmPeach,
        surface: const Color(0xFF2B2520),
        error: AppColors.errorRust,
        onSurface: AppColors.paperBg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1A17),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.paperBg,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: AppColors.paperBg),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2B2520),
        elevation: 2,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.warmTanAccent,
        foregroundColor: const Color(0xFF1E1A17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
    );
  }
}