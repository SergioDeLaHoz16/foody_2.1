import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foody/common/widgets/button.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  // Variables para los campos
  String? selectedCountry;
  String? selectedDepartment;
  String? selectedMunicipality;
  String? selectedVia;
  String? selectedNumber1;
  String? selectedLetter1;
  String? selectedNumber2;
  String? barrio;
  String direccionIntegrada = '';
  bool acceptTerms = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Map<String, List<String>> countryToDepartments = {
    'Perú': ['Lima', 'Cusco', 'Arequipa'],
    'Colombia': ['Antioquia', 'Cundinamarca', 'Valle del Cauca'],
  };

  final Map<String, List<String>> departmentToMunicipalities = {
    'Lima': ['Miraflores', 'San Isidro', 'Barranco'],
    'Cusco': ['Cusco', 'Urubamba', 'Ollantaytambo'],
    'Arequipa': ['Arequipa', 'Cayma', 'Yanahuara'],
    'Antioquia': ['Medellín', 'Envigado', 'Itagüí'],
    'Cundinamarca': ['Bogotá', 'Soacha', 'Chía'],
    'Valle del Cauca': ['Cali', 'Palmira', 'Buenaventura'],
  };

  final Map<String, String> viaAbbreviations = {
    'Calle': 'Cl',
    'Carrera': 'Cr',
    'Transversal': 'Tv',
    'Diagonal': 'Dg',
  };

  final List<String> viasPrincipales = [
    'Calle',
    'Carrera',
    'Transversal',
    'Diagonal',
  ];
  final List<String> letters = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  ); // A-Z
  final List<String> numbers = List.generate(
    99,
    (index) => (index + 1).toString(),
  ); // 1-99

  List<String> departments = [];
  List<String> municipalities = [];

  void updateDireccionIntegrada() {
    setState(() {
      final via = viaAbbreviations[selectedVia] ?? selectedVia ?? '';
      direccionIntegrada =
          '$via ${selectedNumber1 ?? ''}${selectedLetter1 ?? ''} #${selectedNumber2 ?? ''}, ${selectedMunicipality ?? ''}, ${selectedDepartment ?? ''}, ${barrio ?? ''}';
      _authController.updateUserField('direccion', direccionIntegrada);
    });
  }

  void _toggleAcceptTerms(bool? value) {
    setState(() {
      acceptTerms = value ?? false;
    });
  }

  Future<bool> _validateCedula(String cedula) async {
    final exists = await _authController.isCedulaDuplicated(cedula);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El número de cédula ya está registrado')),
      );
      return false;
    }
    return true;
  }

  Future<bool> _validateEmail(String email) async {
    final exists = await _authController.isEmailDuplicated(email);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El correo electrónico ya está registrado'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<bool> _validateForm() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    final cedulaValid = await _validateCedula(
      _authController.user.cedula ?? '',
    );
    final emailValid = await _validateEmail(_authController.user.correo ?? '');
    return cedulaValid && emailValid;
  }

  void _clearFields() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _authController.updateUserField('nombre', '');
      _authController.updateUserField('apellido', '');
      _authController.updateUserField('celular', '');
      _authController.updateUserField('cedula', '');
      _authController.updateUserField('fechaNacimiento', null);
      _authController.updateUserField('correo', '');
      _authController.updateUserField('pais', '');
      _authController.updateUserField('departamento', '');
      _authController.updateUserField('municipio', '');
      _authController.updateUserField('direccion', '');
      _authController.updateUserField('barrio', '');
      _authController.updateUserField('contrasena', '');
      selectedCountry = null;
      selectedDepartment = null;
      selectedMunicipality = null;
      selectedVia = null;
      selectedNumber1 = null;
      selectedLetter1 = null;
      selectedNumber2 = null;
      barrio = null;
      direccionIntegrada = '';
      acceptTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logos/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Acerca de ti',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  onChanged:
                      (value) =>
                          _authController.updateUserField('nombre', value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                  onChanged:
                      (value) =>
                          _authController.updateUserField('apellido', value),
                ),
                const SizedBox(height: 10),
                IntlPhoneField(
                  decoration: const InputDecoration(
                    labelText: 'Número de Celular',
                    border: OutlineInputBorder(),
                  ),
                  initialCountryCode: 'PE',
                  onChanged:
                      (phone) => _authController.updateUserField(
                        'celular',
                        phone.completeNumber,
                      ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número de Cédula',
                    border: OutlineInputBorder(),
                  ),
                  onChanged:
                      (value) =>
                          _authController.updateUserField('cedula', value),
                ),
                const SizedBox(height: 10),
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
                      initialDate: DateTime.now(),
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
                const SizedBox(height: 20),
                const Text(
                  'Correo Electrónico',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                  onChanged:
                      (value) =>
                          _authController.updateUserField('correo', value),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contraseña',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 20),
                const Text(
                  'Dirección',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'País',
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    hintText: selectedCountry ?? 'Seleccione un país',
                  ),
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country.name;
                          _authController.updateUserField('pais', country.name);
                          departments =
                              countryToDepartments[country.name] ?? [];
                          selectedDepartment = null;
                          municipalities = [];
                          selectedMunicipality = null;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Departamento',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDepartment,
                  items:
                      departments
                          .map(
                            (dept) => DropdownMenuItem(
                              value: dept,
                              child: Text(dept),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                      _authController.updateUserField('departamento', value);
                      municipalities = departmentToMunicipalities[value!] ?? [];
                      selectedMunicipality = null;
                      updateDireccionIntegrada();
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Municipio',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedMunicipality,
                  items:
                      municipalities
                          .map(
                            (mun) =>
                                DropdownMenuItem(value: mun, child: Text(mun)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMunicipality = value;
                      _authController.updateUserField('municipio', value);
                      updateDireccionIntegrada();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Vía',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedVia,
                        items:
                            viasPrincipales
                                .map(
                                  (via) => DropdownMenuItem(
                                    value: via,
                                    child: Text(via),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedVia = value;
                            updateDireccionIntegrada();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Número',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedNumber1,
                        items:
                            numbers
                                .map(
                                  (num) => DropdownMenuItem(
                                    value: num,
                                    child: Text(num),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedNumber1 = value;
                            updateDireccionIntegrada();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Letra',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedLetter1,
                        items:
                            letters
                                .map(
                                  (letter) => DropdownMenuItem(
                                    value: letter,
                                    child: Text(letter),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLetter1 = value;
                            updateDireccionIntegrada();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Número 2',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedNumber2,
                        items:
                            numbers
                                .map(
                                  (num) => DropdownMenuItem(
                                    value: num,
                                    child: Text(num),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedNumber2 = value;
                            updateDireccionIntegrada();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Barrio',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      barrio = value;
                      _authController.updateUserField('barrio', value);
                      updateDireccionIntegrada();
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Dirección Integrada',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: direccionIntegrada),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(value: acceptTerms, onChanged: _toggleAcceptTerms),
                    const Expanded(
                      child: Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                WButton(
                  label: 'Registrar',
                  onPressed: () async {
                    if (await _validateForm()) {
                      if (acceptTerms) {
                        await _authController.registerUser(context);
                        _clearFields(); 
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Debe aceptar los términos y condiciones',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
