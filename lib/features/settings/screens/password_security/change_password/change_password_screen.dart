import 'package:flutter/material.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/utils/constants/colors.dart';
import 'widgets/password_input_field.dart';
import 'widgets/reset_password_button.dart';
import 'widgets/password_validator_checklist.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _passwordIsValid = false;

  void _onPasswordChanged(String value) {
    // No hacemos setState aquí directamente, lo hace el checklist por callback
  }

  void _onConfirmChanged(String value) {
    setState(() {});
  }

  bool get _canSubmit =>
      _passwordIsValid && _confirmController.text == _passwordController.text;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final email = AuthController().user.correo;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el correo del usuario')),
      );
      return;
    }
    final success = await AuthController().updatePassword(
      email,
      _passwordController.text.trim(),
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada correctamente')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cambiar Contraseña",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? CColors.light : CColors.secondaryTextColor,
          ),
        ),
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Su nueva contraseña debe ser diferente a las contraseñas utilizadas anteriormente.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            PasswordInputField(
              label: "Contraseña",
              hintText: "Introduce una contraseña segura.",
              controller: _passwordController,
              onChanged: _onPasswordChanged,
            ),
            const SizedBox(height: 12),
            PasswordValidatorChecklist(
              password: _passwordController.text,
              onValidationChanged: (isValid) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _passwordIsValid = isValid;
                    });
                  }
                });
              },
            ),

            const SizedBox(height: 24),
            PasswordInputField(
              label: "Confirmar Contraseña",
              hintText: "Introduce una contraseña segura.",
              controller: _confirmController,
              onChanged: _onConfirmChanged,
            ),

            const Spacer(),
            ResetPasswordButton(
              enabled: _canSubmit,
              onPressed: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
