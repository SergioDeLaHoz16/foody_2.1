import 'package:flutter/material.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/utils/constants/colors.dart';

class IconButtonBox extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;

  const IconButtonBox({
    super.key,
    this.icon,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            imagePath != null
                ? Image.asset(imagePath!, width: 28, height: 28)
                : Icon(icon, color: Colors.green, size: 24),
      ),
    );
  }
}
