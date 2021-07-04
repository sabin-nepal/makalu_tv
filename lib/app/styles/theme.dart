import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:flutter/services.dart';

ThemeData theme = ThemeData(  
  brightness: Brightness.dark,
  fontFamily: 'Mukta',
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.bgColor,
  primaryColor: AppColors.primaryColor,
  accentColor: AppColors.accentColor,
  highlightColor: AppColors.primaryColor,
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Mukta',
  appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      brightness: Brightness.dark,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light)),
  scaffoldBackgroundColor: AppColors.bgColor,
  primaryColor: AppColors.primaryColor,
  accentColor: AppColors.accentColor,
  highlightColor: AppColors.primaryColor,
);
