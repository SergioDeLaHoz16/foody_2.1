import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();
  static ElevatedButtonThemeData
  lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 3, // Aumenta la elevación para que la sombra sea más visible
      foregroundColor: CColors.textBlanco,
      backgroundColor: CColors.secondaryColor,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      textStyle: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
  static ElevatedButtonThemeData
  darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 3, // Aumenta la elevación para que la sombra sea más visible
      foregroundColor: CColors.textBlanco,
      backgroundColor: CColors.primaryButton,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      textStyle: TextStyle(
        fontSize: 15.0,
        color: CColors.secondaryTextColor,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
}
