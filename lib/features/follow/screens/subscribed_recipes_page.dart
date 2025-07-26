import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foody/features/follow/controllers/subscription_controller.dart';
import 'package:foody/features/follow/widgets/subscription_modal.dart';
import 'package:foody/features/profile/screen/widgets/recipe_card.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class TodasMisRecetasScreen extends StatefulWidget {
  final List<Recipe> recetasUsuario;

  const TodasMisRecetasScreen({super.key, required this.recetasUsuario});

  @override
  State<TodasMisRecetasScreen> createState() => _TodasMisRecetasScreenState();
}

class _TodasMisRecetasScreenState extends State<TodasMisRecetasScreen> {
  bool _showBlur = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subscriptionController = SubscriptionController();
      final authController = AuthController();
      final userStatus =
          authController.user.status ?? 'FREE'; // Usa el status real

      await showSubscriptionModal(
        context,
        () {
          setState(() => _showBlur = false);
        },
        isSubscribed: subscriptionController.isSubscribed,
        userStatus: userStatus,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final recetasPublicas =
        widget.recetasUsuario.where((r) => !r.isPrivate).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Todas mis recetas")),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recetasPublicas.length,
            itemBuilder: (_, index) {
              final receta = recetasPublicas[index];
              return RecipeCard(
                id: receta.id,
                imagePath: receta.imageUrl ?? 'assets/logos/logo.png',
                title: receta.name,
                rating: receta.averageRating,
                reviews: 0,
                duration: receta.preparationTime.inMinutes,
                difficulty: int.tryParse(receta.difficulty) ?? 1,
              );
            },
          ),
          if (_showBlur)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
        ],
      ),
    );
  }
}
