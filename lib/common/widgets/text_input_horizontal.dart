import 'package:flutter/material.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class WTextInputFormHorizontal extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const WTextInputFormHorizontal({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dark = THelperFunctions.isDarkMode(context);
    final labelStyle = textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: dark ? Colors.white : Colors.black,
    );
    final hintStyle = textTheme.bodyMedium?.copyWith(
      color: dark ? Colors.white54 : Colors.grey,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: RichText(
              text: TextSpan(
                text: label,
                style: labelStyle,
                children: const [
                  TextSpan(text: '  *', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
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
                    color: dark ? Colors.white : Colors.black,
                    width: 1.5,
                  ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
