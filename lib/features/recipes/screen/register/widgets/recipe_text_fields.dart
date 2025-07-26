import 'package:flutter/material.dart';
import 'package:foody/common/widgets/login/text_input_area_horizontal.dart';
import 'package:foody/common/widgets/text_input_horizontal.dart';
import 'package:foody/features/recipes/screen/register/widgets/recipe_time_fields.dart';
import 'package:foody/utils/constants/categories.dart';

class RecipeTextFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController timeController;
  final TextEditingController caloriesController;
  final String? selectedDifficulty;
  final ValueChanged<String?> onDifficultyChanged;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const RecipeTextFields({
    super.key,
    required this.nameController,
    required this.descController,
    required this.timeController,
    required this.caloriesController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WTextInputFormHorizontal(
          label: 'Nombre de Receta',
          hint: 'Escribe el título de la receta',
          controller: nameController,
        ),
        const SizedBox(height: 12),
        WTextAreaFormHorizontal(
          label: 'Descripción',
          hint: 'Coloca la descripción de la receta',
          controller: descController,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items:
              RecipeCategories.all
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: onCategoryChanged,
          decoration: const InputDecoration(
            labelText: 'Categoría *',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          validator: (value) => value == null ? 'Campo obligatorio' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedDifficulty,
          items:
              [
                'Fácil',
                'Media',
                'Difícil',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onDifficultyChanged,
          decoration: const InputDecoration(
            labelText: 'Dificultad *',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          validator: (value) => value == null ? 'Campo obligatorio' : null,
        ),
        const SizedBox(height: 12),
        RecipeTimeField(controller: timeController),
        const SizedBox(height: 12),
        TextFormField(
          controller: caloriesController,
          decoration: const InputDecoration(
            labelText: 'Calorías',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
