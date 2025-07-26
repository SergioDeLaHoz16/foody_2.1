import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class THelperFunctions {
  THelperFunctions._();

  static Color? getColor(String value) {
    if (value == "red") {
      return Colors.red;
    } else if (value == "blue") {
      return Colors.blue;
    } else if (value == "green") {
      return Colors.green;
    } else if (value == "yellow") {
      return Colors.yellow;
    } else if (value == "purple") {
      return Colors.purple;
    } else if (value == "orange") {
      return Colors.orange;
    } else if (value == "pink") {
      return Colors.pink;
    } else if (value == "brown") {
      return Colors.brown;
    } else if (value == "grey") {
      return Colors.grey;
    } else if (value == "black") {
      return Colors.black;
    } else if (value == "white") {
      return Colors.white;
    } else if (value == "cyan") {
      return Colors.cyan;
    }
    return null;
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  //Para un alerta simple
  static void showAlert(String tittle, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Para manejar el tema de navegacion de pages
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  //Para truncar el texto
  static String truncateText(String text, int maxLenght) {
    if (text.length <= maxLenght) {
      return text;
    } else {
      return '${text.substring(0, maxLenght)}...';
    }
  }

  // Manejo para el modo oscuro
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(Get.context!).size.width;
  }

  static void showDialogBox(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title, style: Theme.of(context).textTheme.titleLarge!),
          content: Text(
            content,
            style: TextStyle(
              color: isDark ? CColors.textCategory : CColors.secondaryTextColor,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark ? CColors.light : CColors.primaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
