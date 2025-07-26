import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    filled: true,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    fillColor: CColors.lightContainer,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 12.0,
    ),
    labelStyle: const TextStyle().copyWith(
      color: CColors.primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    hintStyle: const TextStyle().copyWith(
      color: CColors.secondaryTextColor,
      fontSize: 14,
    ),
    errorStyle: const TextStyle().copyWith(
      fontSize: 16,
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: CColors.primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 4, 4),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: CColors.borderPrimary, width: 1),
    ),
    focusedBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: CColors.borderPrimary, width: 1),
    ),
    errorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(color: Colors.orange, width: 1.5),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    filled: true,
    prefixIconColor: Colors.white,
    suffixIconColor: Colors.white,
    fillColor: const Color.fromARGB(62, 55, 55, 55),
    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 2.0),
    labelStyle: const TextStyle().copyWith(
      color: CColors.textBlanco,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    hintStyle: const TextStyle().copyWith(
      color: CColors.textBlanco,
      fontSize: 14,
    ),
    errorStyle: const TextStyle().copyWith(
      fontSize: 16,
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: CColors.textBlanco,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    border: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 4, 4),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: CColors.borderPrimary, width: 1),
    ),
    focusedBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: CColors.borderPrimary, width: 1),
    ),
    errorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(color: Colors.orange, width: 1.5),
    ),
  );
}
