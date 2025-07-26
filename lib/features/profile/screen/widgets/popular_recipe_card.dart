import 'package:flutter/material.dart';
import 'recipe_card.dart';
import 'package:foody/features/home/screens/detail.dart';

class PopularRecipeCard extends StatefulWidget {
  final String id;
  final String imagePath;
  final String title;
  final double rating;
  final int reviews;
  final int duration;
  final int difficulty;

  const PopularRecipeCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.difficulty,
  });

  @override
  State<PopularRecipeCard> createState() => _PopularRecipeCardState();
}

class _PopularRecipeCardState extends State<PopularRecipeCard> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipeId: widget.id),
          ),
        );
      },
      child: RecipeCard(
        id: widget.id,
        imagePath: widget.imagePath,
        title: widget.title,
        rating: widget.rating,
        reviews: widget.reviews,
        duration: widget.duration,
        difficulty: widget.difficulty,
        isFavorite: isFav,
        onFavoriteTap: (newValue) {
          setState(() => isFav = newValue);
        },
      ),
    );
  }
}
