import 'package:flutter/material.dart';
import 'package:foody/features/favorites/screens/favorites/widgets/category_favorite_section.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/utils/constants/categories.dart';

class GroupedFavoritesList extends StatelessWidget {
  final List<Recipe> recipes;
  const GroupedFavoritesList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Recipe>> grouped = {};

    for (final cat in RecipeCategories.all) {
      grouped[cat] = recipes.where((r) => r.category == cat).toList();
    }

    return ListView.separated(
      itemCount: RecipeCategories.all.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final category = RecipeCategories.all[index];
        final categoryRecipes = grouped[category]!;

        if (categoryRecipes.isEmpty) return const SizedBox.shrink();

        return CategoryFavoriteSection(category: category, recipes: categoryRecipes);
      },
    );
  }
}
