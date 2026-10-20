import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.creamBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepBrown,
        secondary: AppColors.goldenYellow,
        tertiary: AppColors.orangeAccent,
        surface: AppColors.surfaceWhite,
      ),
      textTheme: GoogleFonts.manropeTextTheme().apply(
        bodyColor: AppColors.deepBrown,
        displayColor: AppColors.deepBrown,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: AppColors.deepBrown,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.deepBrown),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldenYellow,
          foregroundColor: AppColors.deepBrown,
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.subtleDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.subtleDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.deepBrown, width: 1.5),
        ),
        hintStyle: GoogleFonts.manrope(
          color: AppColors.deepBrown.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
    );
  }
}