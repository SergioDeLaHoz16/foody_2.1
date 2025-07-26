import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DDeviceUtility {
  // Método para ocultar el teclado
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // Método para ocultar el teclado de forma asíncrona
  static Future<void> hideKeyboardAsync(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // Método para cambiar el color de la barra de estado
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  // Metodos para tener la orientacion del dispositivo w
  static bool isLandScapeOrientation(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  static bool isPortraitOrientation(BuildContext context) {
    final viewInsents = MediaQuery.of(context).viewInsets;
    return viewInsents.bottom != 0;
  }

  // Metodo para full screen
  static Future<void> setFullScreen(bool enable) async {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  // Metodo para obtener el ancho de la pantalla
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(Get.context!).size.width;
  }

  // Metodo para obtener el alto de la pantalla
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double getPixelRatio() {
    return MediaQuery.of(Get.context!).devicePixelRatio;
  }

  // Metodo para obtener el alto de la barra de estado
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).padding.top;
  }

  // Metodo para obtener el alto de la barra de navegacion
  static double getNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).padding.bottom;
  }

  // Metodo para obtener el alto de la barra de navegacion
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  // Metodo para obtener el alto del teclado
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).viewInsets.bottom;
  }

  // Metodo para tener visible el teclado
  static Future<bool> isKeyboardVisible() async {
    return MediaQuery.of(Get.context!).viewInsets.bottom > 0;
  }

  // Metodo para saber si el dispositivo es fisico
  static Future<bool> isPhysicalDevice() async {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // Metodo para vibrar el dispositivo
  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  // Metodo para establecer la orientacion del dispositivo
  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  // Metodo para ocultar la barra de estado
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  // Metodo para mostrar la barra de estado
  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  // Metodo para saber si hay conexion a internet
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Metodo para saber si es android
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  // Metodo para saber si es ios
  static bool isIOS() {
    return Platform.isIOS;
  }

  static void launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri as String);
    } else {
      throw 'Could not launch $url';
    }
  }
}
