import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/theme/custom_themes/appbar_theme.dart';
import 'package:foody/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:foody/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:foody/utils/theme/custom_themes/chip_theme.dart';
import 'package:foody/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:foody/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:foody/utils/theme/custom_themes/text_field_theme.dart';
import 'package:foody/utils/theme/custom_themes/text_theme.dart';

//Usamos la Letra T para refenciar a Theme
//y clase
class TAppTheme {
  //Creamos un constructor privado
  TAppTheme._();
  //Creamos unass variables de tipo ThemeData
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Color.fromRGBO(25, 131, 48, 100),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightButtonSheetStyle,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Color.fromRGBO(25, 131, 48, 100),
    scaffoldBackgroundColor: CColors.dark,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkButtonSheetStyle,

    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
  );
}
