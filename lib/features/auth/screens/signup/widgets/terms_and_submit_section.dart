import 'package:flutter/material.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class TermsAndSubmitSection extends StatefulWidget {
  const TermsAndSubmitSection({super.key});

  @override
  State<TermsAndSubmitSection> createState() => _TermsAndSubmitSectionState();
}

class _TermsAndSubmitSectionState extends State<TermsAndSubmitSection> {
  final AuthController _authController = AuthController();
  bool _acceptedTerms = false;

  void _submit() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
        ),
      );
      return;
    }

    final success = await _authController.registerUser();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar usuario o faltan campos'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirmación',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            title: const Text('Acepto los términos y condiciones'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Registrar'),
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
