import 'package:flutter/material.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/recipes/screen/register/widgets/images_recipe_picker.dart';
import 'package:foody/features/recipes/screen/register/widgets/recipe_text_fields.dart';
import 'package:foody/features/recipes/screen/register/register_2.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class RegisterRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;

  const RegisterRecipeScreen({super.key, this.recipeToEdit});

  @override
  State<RegisterRecipeScreen> createState() => _RegisterRecipeScreenState();
}

class _RegisterRecipeScreenState extends State<RegisterRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _imageUrl;
  bool _isPrivate = false; // <-- Nuevo estado

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _timeController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.recipeToEdit != null) {
      final recipe = widget.recipeToEdit!;
      _nameController.text = recipe.name;
      _descController.text = recipe.description;
      _timeController.text =
          '${recipe.preparationTime.inHours.toString().padLeft(2, '0')}:${(recipe.preparationTime.inMinutes % 60).toString().padLeft(2, '0')}';
      _caloriesController.text = recipe.calories?.toString() ?? '';
      _selectedCategory = recipe.category;
      _selectedDifficulty = recipe.difficulty;
      _imageUrl = recipe.imageUrl;
      _isPrivate = recipe.isPrivate; // <-- Inicializa el estado
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final color = dark ? Colors.white : CColors.secondaryTextColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Recetas',
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
            RecipeImagePicker(
              color: color,
              onImageUploaded: (url) => _imageUrl = url,
            ),
            const SizedBox(height: 16),
            RecipeTextFields(
              nameController: _nameController,
              descController: _descController,
              timeController: _timeController,
              caloriesController: _caloriesController,
              selectedDifficulty: _selectedDifficulty,
              onDifficultyChanged:
                  (val) => setState(() => _selectedDifficulty = val),
              selectedCategory: _selectedCategory,
              onCategoryChanged:
                  (val) => setState(() => _selectedCategory = val),
            ),
            Row(
              children: [
                const Text('Visibilidad:'),
                Switch(
                  value: _isPrivate,
                  onChanged: (val) => setState(() => _isPrivate = val),
                ),
                Text(_isPrivate ? 'Privada' : 'Pública'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onNextPressed,
              child: Text(
                widget.recipeToEdit != null ? "Modificar Receta" : "Siguiente",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeIngredientsStep(
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
            category: _selectedCategory ?? '',
            difficulty: _selectedDifficulty ?? '',
            preparationTime: _parseDuration(_timeController.text.trim()),
            calories: int.tryParse(_caloriesController.text.trim()),
            imageUrl: _imageUrl,
            isPrivate: _isPrivate, // <-- Pasa el valor
            recipeToEdit: widget.recipeToEdit,
          ),
        ),
      );
    }
  }

  Duration _parseDuration(String timeString) {
    final parts = timeString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }
}
