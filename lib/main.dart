import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App - MVC GetX',
      debugShowCheckedModeBanner: false,

      // THEME CONFIGURATION ===============================================
      theme: ThemeData(
        // Background
        scaffoldBackgroundColor: AppColors.background,

        // Primary accent monochrome
        primaryColor: AppColors.accent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.accent,
          secondary: AppColors.textSecondary,
          background: AppColors.background,
        ),

        // Typography
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),

        // AppBar clean minimalis
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.accent),
          foregroundColor: AppColors.textPrimary,
        ),

        // Input TextField theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.greyLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.accent, width: 1.4),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),

      // ROUTING ============================================================
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // TRANSITION =========================================================
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
