import 'package:flutter/material.dart';
import 'package:foody/features/auth/widgets/section_layout.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return SectionLayout(
      sectionTitle: 'Acerca de ti',
      sectionSubtitle:
          'Ingrese sus datos a continuación para crear su cuenta y comenzar.',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) => _authController.updateUserField('nombre', value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) => _authController.updateUserField('apellido', value),
            ),
            const SizedBox(height: 12),
            IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Número de Celular',
                border: OutlineInputBorder(),
              ),
              initialCountryCode: 'CO',
              onChanged:
                  (phone) => _authController.updateUserField(
                    'celular',
                    phone.completeNumber,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Número de Cédula',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) => _authController.updateUserField('cedula', value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
                hintText:
                    _authController.user.fechaNacimiento != null
                        ? _authController.user.fechaNacimiento!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Seleccione una fecha',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _authController.updateUserField(
                      'fechaNacimiento',
                      pickedDate,
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
