import 'package:flutter/material.dart';
import 'package:foody/features/profile/screen/widgets/edit/data_field.dart';
import 'package:foody/features/profile/screen/widgets/edit/label_text_field.dart';

class ProfileFormSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController idController;
  final DateTime? birthDate;
  final VoidCallback onBirthDateTap;

  const ProfileFormSection({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.idController,
    required this.birthDate,
    required this.onBirthDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(label: 'Nombre', controller: firstNameController),
        LabeledTextField(label: 'Apellido', controller: lastNameController),
        LabeledTextField(
          label: 'Correo',
          controller: emailController,
          suffix: 'Verified',
        ),
        LabeledTextField(
          label: 'Celular',
          controller: phoneController,
          suffix: 'Verified',
        ),
        DateField(
          label: 'Fecha de Nacimiento',
          text:
              birthDate != null
                  ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}'
                  : 'Select',
          onTap: onBirthDateTap,
        ),
        LabeledTextField(label: 'Cédula', controller: idController),
      ],
    );
  }
}
