import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foody/features/follow/widgets/keys.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:http/http.dart' as http;

export 'subscription_button.dart';

class StyledSubscriptionButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final bool isSubscribed;
  final String priceText;

  const StyledSubscriptionButton({
    super.key,
    required this.onPressed,
    this.isSubscribed = false,
    this.priceText = '\$ 40.000/mes',
  });

  @override
  State<StyledSubscriptionButton> createState() =>
      _StyledSubscriptionButtonState();
}

class _StyledSubscriptionButtonState extends State<StyledSubscriptionButton> {
  // double amount = 40000;
  // Map<String, dynamic>? intentPaymentData;

  // showPaymentSheet() async {
  //   try {
  //     await Stripe.instance
  //         .presentPaymentSheet()
  //         .then((val) {
  //           intentPaymentData = null;
  //         })
  //         .onError((errorMsg, sTrace) {
  //           if (kDebugMode) {
  //             print(errorMsg.toString() + sTrace.toString());
  //           }
  //         });
  //   } on StripeException catch (error) {
  //     if (kDebugMode) {
  //       print(error);
  //     }
  //     showDialog(
  //       context: context,
  //       builder: (c) => const AlertDialog(content: Text("Cancelado")),
  //     );
  //   } catch (errorMsg) {
  //     if (kDebugMode) {
  //       print(errorMsg);
  //     }
  //     print(errorMsg.toString());
  //   }
  // }

  // makeIntentforPayment(amountTobeCharge, currency) async {
  //   try {
  //     Map<String, dynamic> paymentInfo = {
  //       "amount": (int.parse(amountTobeCharge) * 100).toString(),
  //       "currency": currency,
  //       "payment_method_types[]": "card",
  //     };
  //     var responseFromStripeAPI = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       body: paymentInfo,
  //       headers: {
  //         "Authorization": "Bearer $SecretKey",
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //     );

  //     print("response from API = " + responseFromStripeAPI.body);

  //     return jsonDecode(responseFromStripeAPI.body);
  //   } catch (errorMsg) {
  //     if (kDebugMode) {
  //       print(errorMsg);
  //     }
  //     print(errorMsg.toString());
  //   }
  // }

  // paymentSheetInitialization(amountTobeCharge, currency) async {
  //   try {
  //     intentPaymentData = await makeIntentforPayment(
  //       amountTobeCharge,
  //       currency,
  //     );

  //     await Stripe.instance
  //         .initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //             allowsDelayedPaymentMethods: true,
  //             paymentIntentClientSecret: intentPaymentData!['client_secret'],
  //             style: ThemeMode.dark,
  //             merchantDisplayName: "Foody",
  //           ),
  //         )
  //         .then((val) {
  //           print(val);
  //         });
  //     showPaymentSheet();
  //   } catch (errorMsg, s) {
  //     if (kDebugMode) {
  //       print(s);
  //     }
  //     print(errorMsg.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    final buttonPadding =
        isSmall
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    final iconSize = isSmall ? 16.0 : 20.0;
    final fontSize = isSmall ? 14.0 : 16.0;
    final badgePadding =
        isSmall
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    return ElevatedButton(
      onPressed:
          widget.isSubscribed
              ? null
              : () {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: CColors.primaryButton,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.percent, color: Colors.white, size: iconSize),
          const SizedBox(width: 8),
          Text(
            widget.isSubscribed ? 'Suscrito' : 'Suscribirse',
            // ($priceText)'
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              widget.priceText,
              style: TextStyle(
                color: CColors.primaryButton,
                fontWeight: FontWeight.w600,
                fontSize: fontSize - 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
