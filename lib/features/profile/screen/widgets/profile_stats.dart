import 'package:flutter/material.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/favorites/services/favorite_service.dart';

class ProfileStats extends StatelessWidget {
  final UserProfile user;

  const ProfileStats({super.key, required this.user});

  Future<int> _getTotalFavorites() async {
    // Suma los favoritos de todas las recetas del usuario
    final recipeService = RecipeService();
    final favoriteService = FavoriteService();
    final recipes = await recipeService.fetchRecipes();
    final userRecipes =
        recipes.where((r) => r.createdBy == user.correo).toList();
    int total = 0;
    for (final recipe in userRecipes) {
      total += await favoriteService.getFavoritesCount(recipe.id);
    }
    return total;
  }

  Future<int> _getTotalComments() async {
    // Suma los comentarios de todas las recetas del usuario
    final recipeService = RecipeService();
    final recipes = await recipeService.fetchRecipes();
    final userRecipes =
        recipes.where((r) => r.createdBy == user.correo).toList();
    int total = 0;
    for (final recipe in userRecipes) {
      total += recipe.comments.length;
    }
    return total;
  }

  Future<int> _getTotalRecipes() async {
    final recipeService = RecipeService();
    final recipes = await recipeService.fetchRecipes();
    return recipes.where((r) => r.createdBy == user.correo).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? CColors.darkContainer : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FutureBuilder<int>(
            future: _getTotalRecipes(),
            builder: (context, snapshot) {
              final value = snapshot.hasData ? snapshot.data.toString() : '...';
              return _buildStat("Recetas", value);
            },
          ),
          FutureBuilder<int>(
            future: _getTotalFavorites(),
            builder: (context, snapshot) {
              final value = snapshot.hasData ? snapshot.data.toString() : '...';
              return _buildStat("Favoritos", value);
            },
          ),
          // _buildStat("Seguidores", '${user.seguidores}k'),
          FutureBuilder<int>(
            future: _getTotalComments(),
            builder: (context, snapshot) {
              final value = snapshot.hasData ? snapshot.data.toString() : '...';
              return _buildStat("Reseñas", value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
