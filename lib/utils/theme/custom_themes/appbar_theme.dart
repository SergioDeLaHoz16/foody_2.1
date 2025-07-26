import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    iconTheme: const IconThemeData(color: Colors.black, size: 24.0),
    actionsIconTheme: const IconThemeData(color: Colors.black, size: 24.0),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    iconTheme: const IconThemeData(color: Colors.black, size: 24.0),
    actionsIconTheme: const IconThemeData(color: Colors.white, size: 24.0),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
  );
}
