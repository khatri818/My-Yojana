import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class AppThemes {
  static final ThemeData appTheme = ThemeData(
    primaryColor: const Color(0xff1F1C1C),
    primaryColorDark: const Color(0xff1F1C1C),
    primaryColorLight: const Color(0xff1F1C1C),
    hintColor: AppColors.backgroundColor,
    fontFamily: 'Metropolis',
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
    ),
  );
}
