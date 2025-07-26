import 'package:flutter/material.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/features/home/screens/detail.dart';

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

  @override
  Widget build(BuildContext context) {
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
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Error al cargar sugerencias.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recomendado para ti:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 195,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final recipe = suggestions[index];
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child:
                                  (recipe.imageUrl != null &&
                                          recipe.imageUrl!.isNotEmpty)
                                      ? Image.network(
                                        recipe.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stack) =>
                                                Image.asset(
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
                          const SizedBox(height: 4),
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
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
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                recipe.averageRating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
