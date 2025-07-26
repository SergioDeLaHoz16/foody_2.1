import 'package:flutter/material.dart';
import 'package:foody/common/widgets/difficulty.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/features/home/screens/detail.dart';

class RecipeCard extends StatefulWidget {
  final String id; // <-- Agrega esto
  final String imagePath;
  final String title;
  final double rating;
  final int reviews;
  final int duration;
  final int difficulty;

  /// Si no se provee, el estado se maneja internamente
  final bool? isFavorite;
  final ValueChanged<bool>? onFavoriteTap;

  const RecipeCard({
    super.key,
    required this.id, // <-- Agrega esto
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.difficulty,
    this.isFavorite,
    this.onFavoriteTap,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  late bool _localFavorite;

  // Agrega funciones auxiliares para dificultad
  String _getDifficultyString(int level) {
    switch (level) {
      case 1:
        return 'Fácil';
      case 2:
        return 'Media';
      case 3:
        return 'Difícil';
      default:
        return 'Fácil';
    }
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

  @override
  void initState() {
    super.initState();
    _localFavorite = widget.isFavorite ?? false;
  }

  void _toggleFavorite() {
    if (widget.onFavoriteTap != null) {
      widget.onFavoriteTap!(!(widget.isFavorite ?? _localFavorite));
    } else {
      setState(() => _localFavorite = !_localFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final favorite = widget.isFavorite ?? _localFavorite;

    final difficultyStr = _getDifficultyString(widget.difficulty);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipeId: widget.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 1,
        color: isDark ? CColors.darkContainer : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    widget.imagePath.startsWith('http')
                        ? Image.network(
                          widget.imagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.fill,
                          errorBuilder:
                              (context, error, stackTrace) => Image.asset(
                                'assets/logos/logo.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                        )
                        : Image.asset(
                          widget.imagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.fill,
                        ),
              ),
              const SizedBox(width: 10),
              // Contenido
              Expanded(
                child: Stack(
                  children: [
                    // Contenido principal
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Rating y duración
                        Row(
                          children: [
                            const Icon(
                              Iconsax.star1,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.rating.toStringAsFixed(1)} | ${widget.reviews} reseñas',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Iconsax.clock_14,
                              size: 16,
                              color: CColors.primaryButton,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.duration} min',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Dificultad
                        Text(
                          'Dificultad',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              difficultyStr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getDifficultyColor(difficultyStr),
                              ),
                            ),
                            const SizedBox(width: 8),
                            DifficultyIndicator(level: widget.difficulty),
                          ],
                        ),
                      ],
                    ),

                    // Corazón abajo a la derecha
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: _toggleFavorite,
                        child: Icon(
                          favorite ? Iconsax.heart5 : Iconsax.heart,
                          color: favorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
