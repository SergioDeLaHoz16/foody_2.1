import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class VerTodasButton extends StatelessWidget {
  final VoidCallback onTap;

  const VerTodasButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? CColors.darkContainer : Colors.white,

          borderRadius: BorderRadius.circular(12), // Agregado para redondear
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Todas mis recetas",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Iconsax.arrow_right_3),
          ],
        ),
      ),
    );
  }
}
