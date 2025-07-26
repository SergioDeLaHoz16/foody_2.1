import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class BlurredBackground extends StatelessWidget {
  final VoidCallback onTap;

  const BlurredBackground({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return Positioned.fill(
      child: GestureDetector(
        onTap: onTap,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color:
                isDark
                    ? const Color.fromARGB(141, 19, 33, 22)
                    : const Color.fromARGB(110, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
