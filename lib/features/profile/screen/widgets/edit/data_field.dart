import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class DateField extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onTap;

  const DateField({
    Key? key,
    required this.label,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    final Color labelColor = isDark ? CColors.light : CColors.primaryTextColor;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color underlineColor =
        isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: underlineColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text.isEmpty ? 'Seleccionar fecha' : text,
                      style: TextStyle(
                        fontSize: 16,
                        color: text.isEmpty ? Colors.grey : textColor,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, size: 18, color: underlineColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
