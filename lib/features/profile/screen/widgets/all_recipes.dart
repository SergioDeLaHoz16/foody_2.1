// lib/features/profile/screen/all_recipes.dart
import 'package:flutter/material.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/recipes/screen/register/register.dart';
import '../widgets/recipe_card.dart';

class TodasMisRecetasScreen extends StatefulWidget {
  final List<Recipe> recetasUsuario;

  const TodasMisRecetasScreen({super.key, required this.recetasUsuario});

  @override
  State<TodasMisRecetasScreen> createState() => _TodasMisRecetasScreenState();
}

class _TodasMisRecetasScreenState extends State<TodasMisRecetasScreen> {
  late List<Recipe> _recetas;

  @override
  void initState() {
    super.initState();
    _recetas = List.from(widget.recetasUsuario);
  }

  Future<void> _deleteRecipe(String id) async {
    await RecipeService().deleteRecipe(id);
    setState(() {
      _recetas.removeWhere((r) => r.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receta eliminada exitosamente.')),
    );
  }

  void _editRecipe(Recipe receta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterRecipeScreen(recipeToEdit: receta),
      ),
    );
    setState(() {});
  }

  void _showDeleteConfirmation(BuildContext context, String recetaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar esta receta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                await _deleteRecipe(recetaId); // Llamar función original
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todas mis recetas")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recetas.length,
        itemBuilder: (_, index) {
          final receta = _recetas[index];
          return Column(
            children: [
              Stack(
                children: [
                  RecipeCard(
                    id: receta.id,
                    imagePath: receta.imageUrl ?? 'assets/logos/logo.png',
                    title: receta.name,
                    rating: receta.averageRating,
                    reviews: receta.comments.length,
                    duration: receta.preparationTime.inMinutes,
                    difficulty: int.tryParse(receta.difficulty) ?? 1,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   icon: const Icon(Icons.edit, color: Colors.blue),
                        //   tooltip: 'Editar',
                        //   onPressed: () => _editRecipe(receta),
                        // ),
                        // IconButton(
                        //   icon: const Icon(Icons.delete, color: Colors.red),
                        //   tooltip: 'Eliminar',
                        //   onPressed: () => _deleteRecipe(receta.id),
                        // ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          color: Colors.white,
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    'Editar',
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    'Eliminar',
                                  ),
                                ),
                              ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editRecipe(receta);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, receta.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
