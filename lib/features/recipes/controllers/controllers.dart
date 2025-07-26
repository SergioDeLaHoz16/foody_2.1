import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/recipes/models/models.dart';

class RecipeController {
  void initializeFormFields({
    required Recipe? existingRecipe,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController timeController,
    required TextEditingController caloriesController,
    required TextEditingController instructionsController,
    required Function(String?) setSelectedCategory,
    required Function(String?) setSelectedDifficulty,
    required Function(List<Product>) setIngredients,
  }) {
    if (existingRecipe != null) {
      nameController.text = existingRecipe.name;
      descriptionController.text = existingRecipe.description;
      timeController.text = existingRecipe.preparationTime.inMinutes.toString();
      caloriesController.text = existingRecipe.calories?.toString() ?? '';
      instructionsController.text = existingRecipe.instructions ?? '';
      setSelectedCategory(existingRecipe.category);
      setSelectedDifficulty(existingRecipe.difficulty.toString());
      setIngredients(existingRecipe.ingredients);
    }
  }
}
