import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foody/features/follow/screens/subscription_page.dart';

Future<void> showSubscriptionModal(
  BuildContext context,
  VoidCallback onConfirm, {
  required bool isSubscribed,
  required String userStatus,
}) {
  final isUserSubscribed = userStatus.toUpperCase() == "SUSCRITO";
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUserSubscribed
                ? 'DISFRUTA DE TODAS MIS RECETAS, GRACIAS POR TU APOYO'
                : '¿Quieres ver más?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (!isUserSubscribed)
            const Text(
              'Ayuda al creador suscribiéndote y teniendo recetas únicas hechas por él, además sesiones virtuales y más beneficios.',
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Cierra el modal
            if (isUserSubscribed) {
              // Muestra mensaje de agradecimiento
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Gracias por tu apoyo! Disfruta todas las recetas.'),
                ),
              );
              onConfirm();
            } else {
              // Navega a la página de suscripción
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubscriptionPage(),
                ),
              );
              onConfirm();
            }
          },
          child: Text(
            isUserSubscribed ? 'Ya eres Suscriptor' : 'Suscribirse',
          ),
        ),
      ],
    ),
  );
}

class BlurWidget extends StatelessWidget {
  final bool showBlur;
  final Widget child;

  const BlurWidget({
    Key? key,
    required this.showBlur,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showBlur)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
      ],
    );
  }
}
