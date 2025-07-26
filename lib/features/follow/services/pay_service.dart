import 'package:flutter/material.dart';

class PayService {
  static Future<bool> simulatePayment(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Procesando pago..."),
              ],
            ),
          ),
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    return true;
  }
}
