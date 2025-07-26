import 'package:flutter/material.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/auth/widgets/section_layout.dart';

class EmailPasswordSection extends StatefulWidget {
  final PageController pageController;
  const EmailPasswordSection({super.key, required this.pageController});

  @override
  State<EmailPasswordSection> createState() => _EmailPasswordSectionState();
}

class _EmailPasswordSectionState extends State<EmailPasswordSection> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      sectionTitle: 'Correo y contraseña',
      sectionSubtitle:
          'Ingrese su correo electrónico y cree una contraseña segura.',
      pageController: widget.pageController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) => _authController.updateUserField('correo', value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) =>
                      _authController.updateUserField('contrasena', value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
