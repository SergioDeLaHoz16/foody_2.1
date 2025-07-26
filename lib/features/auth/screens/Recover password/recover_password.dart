import 'package:flutter/material.dart';
import 'package:foody/data/services/auth_service.dart';
import 'package:foody/features/auth/screens/Recover password/reset_password.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingrese su correo electrónico para recuperar su contraseña.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese un correo electrónico'),
                    ),
                  );
                  return;
                }

                // Mostrar ventana de carga
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Row(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Expanded(child: Text('Espera un momento... Estamos verificando tu correo electrónico.')),
                      ],
                    ),
                  ),
                );

                // Esperar 3 segundos
                await Future.delayed(const Duration(seconds: 3));

                final exists = await authService.emailExists(email);

                // Cerrar ventana de carga
                Navigator.of(context).pop();

                if (exists) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El correo electrónico no está registrado',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
