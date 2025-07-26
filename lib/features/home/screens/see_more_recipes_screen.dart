import 'package:flutter/material.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/home/screens/detail.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class SeeMoreRecipesScreen extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const SeeMoreRecipesScreen({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? CColors.light : CColors.primaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.primaryTextColor,
        ),
      ),
      body:
          recipes.isEmpty
              ? Center(
                child: Text(
                  'No hay recetas para mostrar.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              )
              : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    color: isDark ? CColors.darkContainer : Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            recipe.imageUrl != null &&
                                    recipe.imageUrl!.isNotEmpty
                                ? Image.network(
                                  recipe.imageUrl!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/images/1.png',
                                            width: 56,
                                            height: 56,
                                            fit: BoxFit.cover,
                                          ),
                                )
                                : Image.asset(
                                  'assets/images/1.png',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      title: Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.green.shade700,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.preparationTime.inMinutes} min',
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 8),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            recipe.averageRating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            recipe.difficulty,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(recipe.difficulty),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RecipeDetailPage(recipeId: recipe.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Fácil':
        return Colors.green;
      case 'Media':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
