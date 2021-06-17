import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';

ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Mukta',
  appBarTheme: AppBarTheme(
    color:Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.bgColor,
  primaryColor: AppColors.primaryColor,
  accentColor: AppColors.accentColor,
  highlightColor: AppColors.primaryColor,
);
