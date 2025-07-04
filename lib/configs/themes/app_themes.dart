import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_colors.dart';

class AppThemes {
  AppThemes._();

  static ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    canvasColor: AppColors.primaryColor,
    fontFamily: "Lato",
    appBarTheme: const AppBarTheme(color: AppColors.whiteColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    inputDecorationTheme: const InputDecorationTheme(filled: true),
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      // secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: "Lato",
        color: AppColors.primaryColor,
        fontSize: 26,
      ),
      titleMedium: TextStyle(

        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 20,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 16,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 15,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 14,
      ),
      ///////////
      labelMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 10,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 11,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.blackColor,
        fontSize: 13,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.textColor,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.textColor,
        fontSize: 12,
      ),
      displayLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Lato",
        color: AppColors.textColor,
        fontSize: 10,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: "Lato",
        color: AppColors.textColor,
        fontSize: 11,
      ),
    ),
  );
}
