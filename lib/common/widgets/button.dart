import 'package:flutter/material.dart';
import 'package:foody/utils/theme/custom_themes/elevated_button_theme.dart';

class WButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final ButtonStyle? style;
  final bool isGoogleButton;
  final VoidCallback? onPressed;

  const WButton({
    super.key,
    required this.label,
    this.icon,
    this.style,
    this.isGoogleButton = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: (onPressed != null) ? onPressed : () {},
          icon: icon ?? SizedBox.shrink(),
          label: Text(label),
          style:
              style ??
              (isGoogleButton
                  ? ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  )
                  : Theme.of(context).brightness == Brightness.dark
                  ? TElevatedButtonTheme.darkElevatedButtonTheme.style
                  : TElevatedButtonTheme.lightElevatedButtonTheme.style),
        ),
      ),
    );
  }
}
