import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

class WTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const WTextButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? CColors.textBlanco
                  : CColors.resaltar,
        ),
      ),
    );
  }
}
