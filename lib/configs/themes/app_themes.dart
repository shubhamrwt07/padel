import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppThemes {
  AppThemes._();
  static ThemeData appTheme = ThemeData(

    primaryColor: AppColors.primaryColor,
    canvasColor: AppColors.primaryColor,
    fontFamily: "Poppins",
    appBarTheme: const AppBarTheme(
      color: AppColors.whiteColor
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      // secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
  titleLarge:TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: "Poppins",
      color: AppColors.primaryColor,
      fontSize: 26) ,
      titleMedium:   TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
        color: AppColors.blackColor,
        fontSize: 20) ,
      titleSmall:TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 16) ,
      headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 15),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 14),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 12),
      labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 10),
      ///////////
      labelMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 10),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 9),
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          color: AppColors.blackColor,
          fontSize: 8),
      bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
          color: AppColors.textColor,
          fontSize: 12),
      bodySmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: AppColors.textColor,
          fontSize: 10),
    ),
  );
}
