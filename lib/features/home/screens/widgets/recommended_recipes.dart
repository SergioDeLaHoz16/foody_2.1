import 'package:flutter/material.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/features/home/screens/detail.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class RecommendedRecipesWidget extends StatefulWidget {
  final String currentUserEmail;
  const RecommendedRecipesWidget({super.key, required this.currentUserEmail});

  @override
  State<RecommendedRecipesWidget> createState() =>
      _RecommendedRecipesWidgetState();
}

class _RecommendedRecipesWidgetState extends State<RecommendedRecipesWidget> {
  late Future<List<Recipe>> _recommendedRecipesFuture;

  @override
  void initState() {
    super.initState();
    _recommendedRecipesFuture = _fetchRecommendedRecipes();
  }

  @override
  void didUpdateWidget(covariant RecommendedRecipesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentUserEmail != widget.currentUserEmail) {
      setState(() {
        _recommendedRecipesFuture = _fetchRecommendedRecipes();
      });
    }
  }

  Future<List<Recipe>> _fetchRecommendedRecipes() async {
    final inventoryService = InventoryService();
    final recipeService = RecipeService();

    final userEmail = widget.currentUserEmail;
    if (userEmail.isEmpty) {
      return [];
    }

    final allProducts = await inventoryService.fetchProducts();
    final myProducts =
        allProducts
            .where(
              (p) =>
                  (p.createdBy.trim().toLowerCase() ==
                      userEmail.trim().toLowerCase()) &&
                  p.expiryDate.isAfter(DateTime.now()) &&
                  p.quantity > 0,
            )
            .toList();

    final allRecipes = await recipeService.fetchRecipes();

    final suggestions = <Recipe>[];
    for (final recipe in allRecipes) {
      bool canMake = true;
      for (final ingredient in recipe.ingredients) {
        final match = myProducts.firstWhere(
          (p) =>
              p.name.trim().toLowerCase() ==
              ingredient.name.trim().toLowerCase(),
          orElse:
              () => Product(
                id: '',
                name: '',
                category: '',
                entryDate: DateTime.now(),
                expiryDate: DateTime.now(),
                grams: 0,
                quantity: 0,
                photoUrl: '',
                notes: '',
                entradas: [],
                createdBy: '',
              ),
        );
        if (match.id.isEmpty || match.quantity < ingredient.quantity) {
          canMake = false;
          break;
        }
      }
      if (canMake) {
        suggestions.add(recipe);
      }
    }
    return suggestions;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case '1':
        return Colors.green;
      case 'media':
      case '2':
        return Colors.orange;
      case 'difícil':
      case 'dificil':
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case '1':
        return 'Fácil';
      case '2':
        return 'Media';
      case '3':
        return 'Difícil';
      default:
        return difficulty.isNotEmpty ? difficulty : 'Fácil';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    if (widget.currentUserEmail.isEmpty) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<List<Recipe>>(
      future: _recommendedRecipesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Error al cargar sugerencias.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? CColors.light : CColors.primaryTextColor,
              ),
            ),
          );
        }
        final suggestions = snapshot.data ?? [];
        if (suggestions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No hay recetas recomendadas con tus productos actuales.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        }

        // Separar recetas propias y de otros
        final propias =
            suggestions
                .where(
                  (r) =>
                      r.createdBy.trim().toLowerCase() ==
                      widget.currentUserEmail.trim().toLowerCase(),
                )
                .toList();
        final otras =
            suggestions
                .where(
                  (r) =>
                      r.createdBy.trim().toLowerCase() !=
                      widget.currentUserEmail.trim().toLowerCase(),
                )
                .where((r) => !r.isPrivate) 
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Igual que el resto de secciones de home
            _sectionTitle('Recomendado para ti', onPressed: () {}),
            if (propias.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  'Tus recetas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              _buildRecipeList(propias, isPropia: true),
              const SizedBox(height: 8),
            ],
            if (otras.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  'De la comunidad (puedes hacerlas con tus productos)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              _buildRecipeList(otras, isPropia: false),
            ],
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String title, {required VoidCallback onPressed}) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? CColors.light : CColors.primaryTextColor,
          ),
        ),
        TextButton(onPressed: onPressed, child: const Text('')),
      ],
    );
  }

  Widget _buildRecipeList(List<Recipe> recetas, {required bool isPropia}) {
    final isDark = THelperFunctions.isDarkMode(context);
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recetas.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final recipe = recetas[index];
          final difficultyColor = _getDifficultyColor(recipe.difficulty);
          final difficultyText = _getDifficultyText(recipe.difficulty);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(recipeId: recipe.id),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isPropia ? Colors.green : Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isDark ? CColors.darkContainer : CColors.lightContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 110,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child:
                          (recipe.imageUrl != null &&
                                  recipe.imageUrl!.isNotEmpty)
                              ? Image.network(
                                recipe.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stack) => Image.asset(
                                      'assets/images/1.png',
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                'assets/images/1.png',
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      recipe.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: CColors.primaryButton,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.preparationTime.inMinutes} min',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Icon(Icons.star, color: CColors.medium, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          recipe.averageRating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: difficultyColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          difficultyText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: difficultyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
