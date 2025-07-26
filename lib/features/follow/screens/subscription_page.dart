import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foody/features/follow/widgets/keys.dart';
import 'package:foody/features/follow/widgets/subscription_button.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/features/follow/services/pay_service.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:http/http.dart'
    as http; // Asegúrate de importar tu AuthController

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  double amount = 40000;
  Map<String, dynamic>? intentPaymentData;
  final authController = AuthController();

  showPaymentSheet(AuthController authController) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((val) async {
            intentPaymentData = null;
            await authController.updateStatus(
              "SUSCRITO",
            ); // Actualiza el estado a SUSCRITO
            if (context.mounted) {
              Navigator.pop(context, true); // Retorna true si se suscribió
            }
          })
          .onError((errorMsg, sTrace) {
            if (kDebugMode) {
              print(errorMsg.toString() + sTrace.toString());
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pago cancelado o fallido")),
            );
          });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showDialog(
        context: context,
        builder: (c) => const AlertDialog(content: Text("Cancelado")),
      );
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }

  makeIntentforPayment(amountTobeCharge, currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amountTobeCharge) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };
      var responseFromStripeAPI = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $SecretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      print("response from API = ${responseFromStripeAPI.body}");

      return jsonDecode(responseFromStripeAPI.body);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }

  paymentSheetInitialization(amountTobeCharge, currency) async {
    try {
      intentPaymentData = await makeIntentforPayment(
        amountTobeCharge,
        currency,
      );

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              allowsDelayedPaymentMethods: true,
              paymentIntentClientSecret: intentPaymentData!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: "Foody",
            ),
          )
          .then((val) {
            print(val);
          });
      showPaymentSheet(authController);
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Instancia tu controlador

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscripción'),
        backgroundColor: CColors.primaryButton,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suscríbete por solo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$ 40.000/mes',
              style: theme.textTheme.displaySmall?.copyWith(
                color: CColors.primaryButton,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ventajas de la suscripción',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAdvantage('Acceso a recetas exclusivas'),
            _buildAdvantage('Sesiones virtuales con el chef'),
            _buildAdvantage('Descuentos en eventos y talleres'),
            _buildAdvantage('Soporte prioritario'),
            const Spacer(),
            Center(
              child: StyledSubscriptionButton(
                onPressed: () async {
                  await paymentSheetInitialization(
                    amount.round().toString(),
                    "COP",
                  );
                  // await showPaymentSheet(authController);
                  // final pagoExitoso = await PayService.simulatePayment(context);
                  // if (pagoExitoso) {
                  //   await authController.updateStatus(
                  //     "SUSCRITO",
                  //   ); // <-- Aquí actualizas el estado
                  //   Navigator.pop(
                  //     context,
                  //     true,
                  //   ); // Retorna true si se suscribió
                  // }
                },
                isSubscribed: false,
                priceText: '\$ 40.000/mes',
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantage(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: CColors.primaryButton,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
