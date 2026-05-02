import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          displayMedium: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          displaySmall: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleSmall: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          labelMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}