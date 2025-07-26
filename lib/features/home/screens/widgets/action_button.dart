import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = THelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(label, style: textTheme.bodyMedium),
        ),
        SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            heroTag: label,
            onPressed: onPressed,
            backgroundColor:
                isDark ? CColors.darkContainer : CColors.primaryColor,
            child: icon,
          ),
        ),
      ],
    );
  }
}
