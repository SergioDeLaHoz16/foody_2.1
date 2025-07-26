import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foody/data/services/cloudinary_service.dart';
import 'package:foody/features/auth/models/models.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';
import 'package:foody/features/profile/screen/widgets/edit/document_details_section.dart';
import 'package:foody/features/profile/screen/widgets/edit/profile_avatar_section.dart';
import 'package:foody/features/profile/screen/widgets/edit/profile_form_section.dart';
import 'package:foody/features/profile/screen/widgets/edit/save_changes_button.dart';
import 'package:foody/features/profile/screen/widgets/edit/label_text_field.dart';
import 'package:foody/utils/constants/colors.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profileController = ProfileController();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _idController;
  late TextEditingController _bioController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _neighborhoodController;
  DateTime? _birthDate;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.nombre);
    _lastNameController = TextEditingController(text: widget.user.apellido);
    _emailController = TextEditingController(text: widget.user.correo);
    _phoneController = TextEditingController(text: widget.user.celular);
    _idController = TextEditingController(text: widget.user.cedula);
    _bioController = TextEditingController(
      text: widget.user.bio ?? 'Sin biografía',
    );
    _countryController = TextEditingController(text: widget.user.pais);
    _stateController = TextEditingController(text: widget.user.departamento);
    _cityController = TextEditingController(text: widget.user.municipio);
    _addressController = TextEditingController(text: widget.user.direccion);
    _neighborhoodController = TextEditingController(text: widget.user.barrio);
    _birthDate = widget.user.fechaNacimiento;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(primary: CColors.primaryColor),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    String? profileImageUrl;
    if (_profileImage != null) {
      profileImageUrl = await CloudinaryService().uploadImage(_profileImage!);
    }

    final updatedUser = widget.user.copyWith(
      nombre: _firstNameController.text,
      apellido: _lastNameController.text,
      correo: _emailController.text,
      celular: _phoneController.text,
      cedula: _idController.text,
      bio: _bioController.text,
      pais: _countryController.text,
      departamento: _stateController.text,
      municipio: _cityController.text,
      direccion: _addressController.text,
      barrio: _neighborhoodController.text,
      fechaNacimiento: _birthDate,
      avatarUrl: profileImageUrl ?? widget.user.avatarUrl,
    );

    final success = await _profileController.saveUserProfile(updatedUser);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.primaryTextColor,
        ),
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            color: isDark ? CColors.light : CColors.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatarSection(
              onTap: _pickProfileImage,
              imageUrl:
                  _profileImage != null
                      ? _profileImage!.path
                      : widget.user.avatarUrl ?? 'assets/icons/avatar.png',
            ),
            const SizedBox(height: 24),
            const Text(
              'Mi Perfil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ProfileFormSection(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              idController: _idController,
              birthDate: _birthDate,
              onBirthDateTap: _pickBirthDate,
            ),
            const SizedBox(height: 24),
            LabeledTextField(label: 'Biografía', controller: _bioController),
            LabeledTextField(label: 'País', controller: _countryController),
            LabeledTextField(
              label: 'Departamento',
              controller: _stateController,
            ),
            LabeledTextField(label: 'Municipio', controller: _cityController),
            LabeledTextField(
              label: 'Dirección',
              controller: _addressController,
            ),
            LabeledTextField(
              label: 'Barrio',
              controller: _neighborhoodController,
            ),
            const SizedBox(height: 32),
            SaveChangesButton(onPressed: _saveChanges),
          ],
        ),
      ),
    );
  }
}
