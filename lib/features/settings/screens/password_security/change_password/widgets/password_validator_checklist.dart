import 'package:flutter/material.dart';

class PasswordValidatorChecklist extends StatefulWidget {
  final String password;
  final void Function(bool isValid)? onValidationChanged;

  const PasswordValidatorChecklist({
    super.key,
    required this.password,
    this.onValidationChanged,
  });

  @override
  State<PasswordValidatorChecklist> createState() =>
      _PasswordValidatorChecklistState();
}

class _PasswordValidatorChecklistState
    extends State<PasswordValidatorChecklist> {
  bool isMinLength = false;
  bool hasLower = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _validate();
  }

  @override
  void didUpdateWidget(covariant PasswordValidatorChecklist oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validate();
  }

  void _validate() {
    final pass = widget.password;

    final newMinLength = pass.length >= 8;
    final newHasLower = RegExp(r'[a-z]').hasMatch(pass);
    final newHasUpper = RegExp(r'[A-Z]').hasMatch(pass);
    final newHasNumber = RegExp(r'\d').hasMatch(pass);
    final newHasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pass);

    final isValid =
        newMinLength &&
        newHasLower &&
        newHasUpper &&
        newHasNumber &&
        newHasSpecial;

    setState(() {
      isMinLength = newMinLength;
      hasLower = newHasLower;
      hasUpper = newHasUpper;
      hasNumber = newHasNumber;
      hasSpecial = newHasSpecial;
    });

    widget.onValidationChanged?.call(isValid);
  }

  Widget _buildRow(bool condition, String text) {
    return Row(
      children: [
        Icon(
          condition ? Icons.check_circle : Icons.cancel,
          color: condition ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: condition ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(hasLower, "Debe tener al menos una letra minúscula"),
        _buildRow(hasUpper, "Debe tener al menos una letra mayúscula"),
        _buildRow(hasNumber, "Debe tener al menos un número"),
        _buildRow(hasSpecial, "Debe tener al menos un carácter especial"),
        _buildRow(isMinLength, "Debe tener mínimo 8 caracteres"),
      ],
    );
  }
}
