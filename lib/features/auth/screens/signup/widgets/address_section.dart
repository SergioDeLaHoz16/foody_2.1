import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/auth/widgets/section_layout.dart';

class AddressSection extends StatefulWidget {
  final PageController pageController;
  const AddressSection({super.key, required this.pageController});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  final AuthController _authController = AuthController();

  String? selectedCountry;
  String? selectedDepartment;
  String? selectedMunicipality;
  String? selectedVia;
  String? selectedNumber1;
  String? selectedLetter1;
  String? selectedNumber2;
  String? barrio;
  String direccionIntegrada = '';

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
  );
  final List<String> numbers = List.generate(
    99,
    (index) => (index + 1).toString(),
  );

  List<String> departments = [];
  List<String> municipalities = [];

  void updateDireccionIntegrada() {
    final via = viaAbbreviations[selectedVia] ?? selectedVia ?? '';
    setState(() {
      direccionIntegrada =
          '$via ${selectedNumber1 ?? ''}${selectedLetter1 ?? ''} #${selectedNumber2 ?? ''}, ${selectedMunicipality ?? ''}, ${selectedDepartment ?? ''}, ${barrio ?? ''}';
      _authController.updateUserField('direccion', direccionIntegrada);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      sectionTitle: 'Dirección',
      sectionSubtitle: 'Complete su dirección para finalizar el registro.',
      pageController: widget.pageController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      departments = countryToDepartments[country.name] ?? [];
                      selectedDepartment = null;
                      municipalities = [];
                      selectedMunicipality = null;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Departamento',
                border: OutlineInputBorder(),
              ),
              value: selectedDepartment,
              items:
                  departments
                      .map(
                        (dept) =>
                            DropdownMenuItem(value: dept, child: Text(dept)),
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
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Municipio',
                border: OutlineInputBorder(),
              ),
              value: selectedMunicipality,
              items:
                  municipalities
                      .map(
                        (mun) => DropdownMenuItem(value: mun, child: Text(mun)),
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: direccionIntegrada),
              decoration: const InputDecoration(
                labelText: 'Dirección Integrada',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
