import 'package:flutter/material.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,

      shadowColor: Colors.black,

      side: BorderSide(color: Colors.blue, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      shadowColor: Colors.white,
      side: BorderSide(color: Colors.blue, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
