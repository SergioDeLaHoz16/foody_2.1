import 'package:flutter/material.dart';
import 'package:foody/utils/constants/images_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image(
              height: 200,
              image: AssetImage(
                dark ? CImages.darkAppLogo : CImages.lightAppLogo,
              ),
            ),
          ),
          Text(
            'Welcome Back',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Text(
            'Encantado de verte de nuevo 😊',
            style: Theme.of(context).textTheme.headlineSmall!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Inicie sesión en su cuenta a continuación',
            style: Theme.of(context).textTheme.bodyMedium!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
