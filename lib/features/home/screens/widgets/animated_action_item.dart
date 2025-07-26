import 'package:flutter/material.dart';
import 'action_button.dart';

class AnimatedActionItem extends StatelessWidget {
  final bool visible;
  final String label;
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;

  const AnimatedActionItem({
    super.key,
    required this.visible,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: visible ? const Offset(0, 0) : const Offset(0, 0.5),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: ActionButton(icon: icon, label: label, onPressed: onPressed),
      ),
    );
  }
}
