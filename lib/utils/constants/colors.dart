import 'package:flutter/material.dart';

class CColors {
  CColors._();

  // Colores de la aplicación basicos
  static const Color primaryColor = Color.fromARGB(255, 25, 131, 48);
  static const Color secondaryColor = Color.fromRGBO(31, 175, 63, 1);
  static const Color resaltar = Color.fromRGBO(30, 103, 46, 1);
  // Colores de texto
  static const Color primaryTextColor = Color.fromRGBO(0, 0, 0, 0.8);
  static const Color secondaryTextColor = Color.fromRGBO(51, 51, 51, 8);
  static const Color textBlanco = Colors.white;
  static const Color textCategory = Color.fromRGBO(189, 189, 189, 0.808);
  static const Color textError = Color(0xFF9D1414);
  static const Color textWarning = Color(0xFFFF8F00);
  static const Color textInfo = Color(0xFF1FAF3F);
  static const Color textMore = Color(0xFF1E672E);
  // Colores de fondo
  static const Color light = Color.fromRGBO(255, 255, 255, 1);
  static const Color dark = Color.fromRGBO(19, 33, 22, 1);
  //Color Seleccionado
  static const Color selected = Color.fromRGBO(0, 0, 0, 10);
  static const Color selectedText = Color(0xFF027E1E);
  //Color de fondo del contenedor
  static const Color lightContainer = Color(0xFFF3F3F3);
  static Color? darkContainer = Colors.grey[850];
  static const Color errorContainer = Color(0xFFEDAAAA);
  static const Color warningContainer = Color.fromRGBO(255, 143, 0, 50);
  //Color de Botones
  static const Color primaryButton = Color(0xFF1FAF3F);
  static const Color secondaryButton = Colors.white;
  static const Color primaryButtonDisabled = Color(0xFFF0F0F0);
  // Color Border
  static const Color borderPrimary = Color(0xFFD5D5D5);
  static const Color borderError = Color(0xFF9D1414);
  static const Color borderWarning = Color(0xFFFF8F00);
  // Color de error
  static const Color easy = Color(0xFF029923);
  static const Color medium = Color(0xFFFAAC2B);
  static const Color hard = Color(0xFF9D1414);
}
