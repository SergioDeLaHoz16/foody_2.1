import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class WTextAreaFormVertical extends StatelessWidget {
  final String label;
  final String hint;
  final String? helperText;
  final TextEditingController controller;
  final int maxLines;

  const WTextAreaFormVertical({
    super.key,
    required this.label,
    required this.hint,
    this.helperText,
    required this.controller,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dark = THelperFunctions.isDarkMode(context);

    final labelStyle = textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: dark ? CColors.light : CColors.secondaryTextColor,
    );

    final hintStyle = textTheme.bodyMedium?.copyWith(
      color: dark ? Colors.white54 : Colors.grey,
    );

    final helperStyle = textTheme.bodySmall?.copyWith(
      color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: labelStyle,
            children: const [
              TextSpan(text: '  *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(helperText!, style: helperStyle),
        ],
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle,
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: dark ? CColors.light : CColors.dark,
                width: 1.5,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          style: textTheme.bodyMedium?.copyWith(
            color: dark ? Colors.white : CColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
