// lib/features/recipes/screen/register/register_2.dart
import 'dart:io';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:foody/common/widgets/card.dart';
import 'package:foody/common/widgets/text_input_vertical.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/recipes/screen/register/widgets/product_selection_modal.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:foody/data/services/cloudinary_service.dart';
import 'package:foody/features/navigation/navigation.dart';

class RecipeIngredientsStep extends StatefulWidget {
  final String name;
  final String description;
  final String category;
  final String difficulty;
  final Duration preparationTime;
  final int? calories;
  final String? imageUrl;
  final Recipe? recipeToEdit;
  final bool isPrivate; 

  const RecipeIngredientsStep({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.preparationTime,
    this.calories,
    this.imageUrl,
    this.recipeToEdit,
    required this.isPrivate,
  });

  @override
  State<RecipeIngredientsStep> createState() => _RecipeIngredientsStepState();
}

class _RecipeIngredientsStepState extends State<RecipeIngredientsStep> {
  final TextEditingController instruccionesController = TextEditingController();
  final InventoryService _inventoryService = InventoryService();
  final RecipeService _recipeService = RecipeService();
  final List<Product> _selectedIngredients = [];
  List<Product> _availableProducts = [];
  String? _videoPath;
  
  @override
  void initState() {
    super.initState();
    _loadAvailableProducts();
    if (widget.recipeToEdit != null) {
      final recipe = widget.recipeToEdit!;
      instruccionesController.text = recipe.instructions ?? '';
      _videoPath = recipe.videoUrl;
      _selectedIngredients.addAll(recipe.ingredients);
    }
  }

  Future<void> _loadAvailableProducts() async {
    final products = await _inventoryService.fetchProducts();
    final userEmail = AuthController().user.correo ?? '';
    setState(() {
      _availableProducts =
          products.where((p) => p.createdBy == userEmail).toList();
    });
  }

  @override
  void dispose() {
    instruccionesController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final cloudinaryService = CloudinaryService();
      final uploadedUrl = await cloudinaryService.uploadImage(
        File(pickedFile.path),
      );
      if (uploadedUrl != null) {
        setState(() {
          _videoPath = uploadedUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir el video a Cloudinary')),
        );
      }
    }
  }

  Future<void> _publishRecipe() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un ingrediente.'),
        ),
      );
      return;
    }

    if (widget.recipeToEdit == null) {
      for (final ingredient in _selectedIngredients) {
        final product = _availableProducts.firstWhere(
          (p) => p.id == ingredient.id,
        );
        if (ingredient.quantity > product.quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Stock insuficiente para el producto: ${product.name}. Disponible: ${product.quantity}',
              ),
            ),
          );
          return;
        }
      }
    }

    final recipe = Recipe(
      id: widget.recipeToEdit?.id ?? const Uuid().v4(),
      name: widget.name,
      description: widget.description,
      category: widget.category,
      difficulty: widget.difficulty,
      preparationTime: widget.preparationTime,
      calories: widget.calories,
      ingredients: _selectedIngredients,
      instructions: instruccionesController.text.trim(),
      imageUrl: widget.imageUrl,
      videoUrl: _videoPath,
      createdBy:
          widget.recipeToEdit?.createdBy ?? AuthController().user.correo ?? '',
      isPrivate: widget.isPrivate, // <-- Guarda el valor
    );

    try {
      if (widget.recipeToEdit != null) {
        await _recipeService.updateRecipe(recipe.id, recipe.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receta modificada exitosamente.')),
        );
      } else {
        for (final ingredient in _selectedIngredients) {
          final product = _availableProducts.firstWhere(
            (p) => p.id == ingredient.id,
          );
          final updatedQuantity = product.quantity - ingredient.quantity;
          await _inventoryService.updateProduct(product.id, {
            'quantity': updatedQuantity,
          });
          // Registrar en historial de productos usados
          await _inventoryService.registerUsedProduct(
            productId: product.id,
            productName: product.name,
            usedQuantity: ingredient.quantity,
            recipeId: recipe.id,
            recipeName: recipe.name,
            usedBy: recipe.createdBy,
            usedDate: DateTime.now(),
          );
        }
        await _recipeService.saveRecipe(recipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receta publicada exitosamente.')),
        );
      }
      // Ir al HomeScreen y limpiar la pila de navegación
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const NavigationScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al ${widget.recipeToEdit != null ? 'modificar' : 'publicar'} la receta: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textColor = dark ? Colors.white : CColors.primaryTextColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Recetas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ingredientes ',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: textColor),
                ),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 73,
                  alignment: Alignment.center,
                  child: Text(
                    'Cantidad',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Productos',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children:
                  _selectedIngredients.map((ingredient) {
                    return IngredienteCard(
                      nombre: ingredient.name,
                      cantidad: ingredient.quantity.toString(),
                      unidad:
                          ingredient.grams != null
                              ? '${ingredient.grams}g'
                              : 'Unidad',
                      imagen: ingredient.photoUrl ?? 'assets/logos/logo.png',
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () async {
                  final selected = await showModalBottomSheet<List<Product>>(
                    context: context,
                    builder: (context) {
                      return ProductSelectionPage(
                        products: _availableProducts,
                        selectedProducts: _selectedIngredients,
                        onSelected: (selectedProducts) {
                          setState(() {
                            _selectedIngredients.clear();
                            _selectedIngredients.addAll(selectedProducts);
                          });
                        },
                      );
                    },
                  );

                  if (selected != null) {
                    setState(() {
                      _selectedIngredients.clear();
                      _selectedIngredients.addAll(selected);
                    });
                  }
                },
                backgroundColor: CColors.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            WTextAreaFormVertical(
              label: 'Instrucciones',
              hint: 'Describe los pasos de tu receta...',
              helperText:
                  'Pasos para realizar la receta.\n(Recuerda realizar por listas)\n\nEj:\n1. Echar la comida en el caldero\n2. Prender el fogón y esperar',
              controller: instruccionesController,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Subir Video Tutorial (Opcional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text('Seleccionar Video'),
            ),
            if (_videoPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Video seleccionado: ${_videoPath!.split('/').last}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _publishRecipe,
              child: Text(
                widget.recipeToEdit != null
                    ? 'Modificar Receta'
                    : 'Publicar Receta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
