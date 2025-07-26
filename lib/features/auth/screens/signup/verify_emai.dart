import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody/common/widgets/button.dart';
import 'package:foody/common/widgets/text_button.dart';
import 'package:foody/features/auth/screens/login/login.dart';
import 'package:foody/features/navigation/navigation.dart';
import 'package:foody/utils/constants/images_strings.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Image(
                image: AssetImage(
                  dark ? CImages.darkAppLogo : CImages.lightAppLogo,
                ),
                width: 200,
              ),

              // Título y subtítulo
              Text(
                'Verifica tu correo electrónico',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                'examplescorreo@examples.com',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text(
                'Felicidades, te has registrado correctamente en Foody! Por favor, revisa tu bandeja de entrada y haz clic en el enlace para verificar tu cuenta.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Botón de continuar
              WButton(
                label: 'Continuar',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => NavigationScreen()),
                  );
                },
              ),
              WTextButton(
                label: 'Reenviar correo',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
