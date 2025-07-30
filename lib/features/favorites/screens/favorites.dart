import 'package:flutter/material.dart';
import 'package:foody/features/favorites/screens/favorites/widgets/favorite_search_bar.dart';
import 'package:foody/features/favorites/screens/favorites/widgets/grouped_favorites_list.dart';
import 'package:provider/provider.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/features/navigation/screens/widgets/appBar.dart';
import 'package:foody/features/favorites/controllers/favorite_controller.dart';
import 'package:foody/data/services/auth_service.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/providers/data_provider.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail =
        Provider.of<DataProvider>(context, listen: false).currentUser?.correo ??
        '';
    final isDark = THelperFunctions.isDarkMode(context);

    return ChangeNotifierProvider(
      create: (_) => FavoriteController()..loadFavorites(userEmail),
      child: Consumer<FavoriteController>(
        builder: (context, favCtrl, _) {
          return FutureBuilder<List<Recipe>>(
            future: RecipeService().fetchRecipes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final favoriteRecipes =
                  snapshot.data!
                      .where((r) => favCtrl.isFavorite(r.id))
                      .toList();

              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CustomAppBar(),
                      _sectionTitle(context, 'Colecciones'),
                      const FavoriteSearchBar(),
                      const SizedBox(height: 16),
                      Expanded(
                        child:
                            favoriteRecipes.isNotEmpty
                                ? GroupedFavoritesList(recipes: favoriteRecipes)
                                : const Center(
                                  child: Text(
                                    'No tienes recetas favoritas aún.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : CColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
