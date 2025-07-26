import 'package:flutter/material.dart';
import 'package:foody/features/auth/screens/login/widgets/login_form.dart';
import 'package:foody/utils/constants/colors.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.widget});

  final LoginForm widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: widget.dark ? CColors.lightContainer : CColors.resaltar,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.only(left: 30, right: 10),
          ),
        ),
        const Text(
          'O',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: widget.dark ? CColors.lightContainer : CColors.resaltar,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.only(left: 10, right: 30),
          ),
        ),
      ],
    );
  }
}
