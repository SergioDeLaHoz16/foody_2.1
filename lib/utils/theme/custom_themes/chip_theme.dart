import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: Colors.white,
    deleteIconColor: Colors.black,
    disabledColor: Colors.grey,
    selectedColor: Colors.blue,
    secondarySelectedColor: Colors.blue,
    shadowColor: Colors.black,
    selectedShadowColor: Colors.black,
    showCheckmark: false,
    checkmarkColor: Colors.black,
    labelPadding: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    secondaryLabelStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    brightness: Brightness.light,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: Colors.black,
    deleteIconColor: Colors.white,
    disabledColor: Colors.grey,
    selectedColor: Colors.blue,
    secondarySelectedColor: Colors.blue,
    shadowColor: Colors.white,
    selectedShadowColor: Colors.white,
    showCheckmark: false,
    checkmarkColor: Colors.white,
    labelPadding: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    secondaryLabelStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    ),
    brightness: Brightness.dark,
  );
}
