import 'package:flutter/material.dart';
import 'package:foody/features/home/screens/search_screen.dart';
import 'package:foody/features/navigation/screens/widgets/appBar.dart';
import 'package:foody/providers/data_provider.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:foody/features/favorites/controllers/favorite_controller.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/utils/constants/categories.dart';
import 'package:foody/features/home/screens/detail.dart';

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
              final allRecipes = snapshot.data!;
              final favoriteRecipes =
                  allRecipes.where((r) => favCtrl.isFavorite(r.id)).toList();

              // Agrupar por categoría de recetas
              final categories = RecipeCategories.all;
              final Map<String, List<Recipe>> grouped = {};
              for (final cat in categories) {
                grouped[cat] =
                    favoriteRecipes.where((r) => r.category == cat).toList();
              }

              final hasFavorites = favoriteRecipes.isNotEmpty;

              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomAppBar(),
                      _sectionTitle(context, 'Colecciones'),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? CColors.darkContainer
                                    : CColors.lightContainer,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(141, 0, 0, 0),
                                blurRadius: 3,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 9.0),
                                child: Icon(Icons.search, color: Colors.grey),
                              ),
                              Text(
                                'Buscar recetas, productos o usuarios...',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child:
                            hasFavorites
                                ? ListView.separated(
                                  itemCount: categories.length,
                                  separatorBuilder:
                                      (context, index) => const Divider(
                                        height: 16,
                                        color: Colors.transparent,
                                      ),
                                  itemBuilder: (context, index) {
                                    final cat = categories[index];
                                    final recipes = grouped[cat]!;
                                    if (recipes.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    final showRecipes =
                                        recipes.length > 3
                                            ? recipes.sublist(0, 3)
                                            : recipes;
                                    final extraCount =
                                        recipes.length > 3
                                            ? recipes.length - 3
                                            : 0;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cat,
                                              style: const TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            _AllFavoritesCategoryScreen(
                                                              category: cat,
                                                              recipes: recipes,
                                                            ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Ver más',
                                                style: TextStyle(
                                                  color:
                                                      isDark
                                                          ? CColors.light
                                                          : CColors
                                                              .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            // Grande a la izquierda
                                            Expanded(
                                              flex: 2,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            _,
                                                          ) => RecipeDetailPage(
                                                            recipeId:
                                                                showRecipes[0]
                                                                    .id,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10,
                                                      ), // Redondear esquinas
                                                  child: _RecipeImageCard(
                                                    recipe: showRecipes[0],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Dos pequeñas a la derecha
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  if (showRecipes.length > 1)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    _,
                                                                  ) => RecipeDetailPage(
                                                                    recipeId:
                                                                        showRecipes[1]
                                                                            .id,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: _RecipeImageCard(
                                                          recipe:
                                                              showRecipes[1],
                                                          height: 66,
                                                        ),
                                                      ),
                                                    ),
                                                  if (showRecipes.length > 2)
                                                    const SizedBox(height: 8),
                                                  if (showRecipes.length > 2)
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        _,
                                                                      ) => RecipeDetailPage(
                                                                        recipeId:
                                                                            showRecipes[2].id,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            child: _RecipeImageCard(
                                                              recipe:
                                                                  showRecipes[2],
                                                              height: 66,
                                                            ),
                                                          ),
                                                        ),
                                                        if (extraCount > 0)
                                                          Positioned(
                                                            bottom: 8,
                                                            right: 8,
                                                            child: Container(
                                                              color:
                                                                  Colors
                                                                      .black54,
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical: 2,
                                                                  ),
                                                              child: Text(
                                                                '+$extraCount Recetas',
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                )
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

  Widget _sectionTitle(
    BuildContext context,
    String title, {
    VoidCallback? onPressed,
  }) {
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
          if (onPressed != null)
            IconButton(
              icon: Icon(
                Icons.add,
                color: isDark ? Colors.white : CColors.secondaryTextColor,
              ),
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}

class _RecipeImageCard extends StatelessWidget {
  final Recipe recipe;
  final double height;
  const _RecipeImageCard({required this.recipe, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      recipe.imageUrl ?? '',
      fit: BoxFit.cover,
      height: height,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, size: 50, color: Colors.red);
      },
    );
  }
}

class _AllFavoritesCategoryScreen extends StatelessWidget {
  final String category;
  final List<Recipe> recipes;
  const _AllFavoritesCategoryScreen({
    required this.category,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritas: $category',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : CColors.secondaryTextColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : CColors.secondaryTextColor,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            leading:
                recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                    ? Image.network(
                      recipe.imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                    : Image.asset('assets/images/1.png', width: 56, height: 56),
            title: Text(recipe.name),
            subtitle: Text(
              'Rating: ${recipe.averageRating.toStringAsFixed(1)}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(recipeId: recipe.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
