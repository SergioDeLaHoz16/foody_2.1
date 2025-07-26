import 'dart:io';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:foody/features/inventory/controllers/controllers.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/utils/constants/categories.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:foody/data/services/cloudinary_service.dart';

class RegisterProductScreen extends StatefulWidget {
  final Product? existingProduct;

  const RegisterProductScreen({super.key, this.existingProduct});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gramsController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final ProductController _productController = ProductController();
  final InventoryService _inventoryService = InventoryService();
  String? _selectedCategory;
  String? _photoPath;
  DateTime? _selectedExpiryDate;
  String? _imageUrl;
  bool _imageError = false;
  bool _categoryError = false;
  bool _expiryDateError = false;

  @override
  void initState() {
    super.initState();
    _productController.initializeFormFields(
      existingProduct: widget.existingProduct,
      nameController: _nameController,
      gramsController: _gramsController,
      quantityController: _quantityController,
      notesController: _notesController,
      setSelectedCategory: (value) => _selectedCategory = value,
      setPhotoPath: (value) => _photoPath = value,
    );
    if (widget.existingProduct != null) {
      _selectedExpiryDate = widget.existingProduct!.expiryDate;
      _photoPath = widget.existingProduct!.photoUrl;
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final cloudinaryService = CloudinaryService();
      final uploadedUrl = await cloudinaryService.uploadImage(
        File(pickedFile.path),
      );
      if (uploadedUrl != null) {
        setState(() {
          _photoPath = uploadedUrl;
          _imageError = false;
        });
      } else {
        setState(() {
          _imageError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al subir la imagen a Cloudinary'),
          ),
        );
      }
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedExpiryDate = pickedDate;
        _expiryDateError = false;
      });
    }
  }

  Future<void> _saveProduct() async {
    setState(() {
      _imageError = _photoPath == null;
      _categoryError = _selectedCategory == null;
      _expiryDateError = _selectedExpiryDate == null;
    });

    final userEmail = AuthController().user.correo ?? '';
    if (_formKey.currentState!.validate() &&
        !_imageError &&
        !_categoryError &&
        !_expiryDateError) {
      final entry = Entry(
        entryDate: DateTime.now(),
        expiryDate: _selectedExpiryDate!,
        grams:
            _gramsController.text.isNotEmpty
                ? double.tryParse(_gramsController.text.trim())
                : null,
        quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      );

      final product = Product(
        id: widget.existingProduct?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _selectedCategory!,
        photoUrl: _photoPath,
        notes:
            _notesController.text.isNotEmpty
                ? _notesController.text.trim()
                : null,
        entradas: widget.existingProduct?.entradas ?? [entry],
        entryDate: entry.entryDate,
        expiryDate: entry.expiryDate,
        quantity: entry.quantity,
        createdBy: userEmail,
      );

      try {
        await _inventoryService.saveProduct(product);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final color = dark ? CColors.light : CColors.secondaryTextColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingProduct == null
              ? 'Registrar Producto'
              : 'Editar Producto',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: const BackButton(),
        iconTheme: IconThemeData(
          color: dark ? CColors.light : CColors.primaryTextColor,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Imagen y carga
            Text(
              'Imagen del producto *',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _imageError ? Colors.red : color,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: dark ? Colors.black12 : Colors.grey[100],
                ),
                child:
                    _photoPath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _photoPath!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        : Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: color,
                            size: 48,
                          ),
                        ),
              ),
            ),
            if (_imageError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'La imagen es obligatoria',
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              ),
            const SizedBox(height: 20),

            // Nombre
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre *',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? 'El nombre es obligatorio'
                          : null,
            ),
            const SizedBox(height: 16),

            // Categoría
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items:
                  ProductCategories.all
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _categoryError = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Categoría *',
                border: OutlineInputBorder(),
                errorText:
                    _categoryError ? 'La categoría es obligatoria' : null,
              ),
              validator: (_) => null, // Usamos errorText arriba
            ),
            const SizedBox(height: 16),

            // Gramos
            TextFormField(
              controller: _gramsController,
              decoration: InputDecoration(
                labelText: 'Gramos (opcional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Cantidad
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Cantidad *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La cantidad es obligatoria';
                }
                final n = int.tryParse(value);
                if (n == null || n < 1) {
                  return 'La cantidad debe ser al menos 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Fecha de caducidad
            Text(
              'Fecha de caducidad *',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickExpiryDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Seleccionar Fecha'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: dark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                if (_selectedExpiryDate != null)
                  Text(
                    'Fecha: ${_selectedExpiryDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.green),
                  ),
              ],
            ),
            if (_expiryDateError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'La fecha de caducidad es obligatoria',
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              ),
            const SizedBox(height: 16),

            // Notas
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: CColors.primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Guardar Producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
