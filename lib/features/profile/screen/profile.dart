// lib/features/profile/screen/profile.dart
import 'package:flutter/material.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/features/profile/screen/edit_profile.dart';
import 'package:foody/features/profile/screen/widgets/all_recipes.dart';
import 'package:foody/features/profile/screen/widgets/recipe_card.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/popular_recipe_card.dart';
import 'widgets/ver_todas_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _ctrl;
  List<Recipe> _misRecetas = [];

  @override
  void initState() {
    super.initState();
    _ctrl = ProfileController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = AuthController().user.correo;
    print('DEBUG: Email obtenido: $email');
    if (email == null || email.isEmpty) {
      print('El correo del usuario está vacío. No se puede cargar el perfil.');
      return;
    }
    print('Correo obtenido del AuthController: $email');

    final recipeService = RecipeService();
    try {
      final todasLasRecetas = await recipeService.fetchRecipes();
      print('DEBUG: Recetas obtenidas: ${todasLasRecetas.length}');
      setState(() {
        _misRecetas =
            todasLasRecetas
                .where((receta) => receta.createdBy == email)
                .toList();
        print('DEBUG: Mis recetas filtradas: ${_misRecetas.length}');
      });
    } catch (e) {
      print('ERROR al obtener recetas: $e');
    }

    try {
      await _ctrl.loadUserProfile(email);
      print('DEBUG: Perfil cargado: ${_ctrl.userProfile}');
      setState(() {});
    } catch (e) {
      print('ERROR al cargar perfil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: Entrando a build. userProfile: ${_ctrl.userProfile}');
    final theme = Theme.of(context);
    final isDark = THelperFunctions.isDarkMode(context);

    if (_ctrl.userProfile == null) {
      print('DEBUG: userProfile es null, mostrando CircularProgressIndicator');
      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil', style: theme.textTheme.titleLarge),
          backgroundColor: isDark ? CColors.dark : CColors.light,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final UserProfile userProfile = _ctrl.userProfile!;

    print('DEBUG: Renderizando pantalla de perfil');

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: theme.textTheme.titleLarge),
        backgroundColor: isDark ? CColors.dark : CColors.light,
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.secondaryTextColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              user: userProfile,
              onEdit: () {
                THelperFunctions.navigateToScreen(
                  context,
                  EditProfileScreen(user: userProfile),
                );
              },
            ),
            const SizedBox(height: 90),
            ProfileStats(user: userProfile),
            const SizedBox(height: 20),
            Text("Receta Popular", style: theme.textTheme.titleMedium),
            (_misRecetas.isNotEmpty)
                ? PopularRecipeCard(
                  id:
                      (_misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .id),
                  imagePath:
                      (_misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .imageUrl) ??
                      'assets/logos/logo.png',
                  title:
                      _misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .name,
                  rating:
                      _misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .averageRating,
                  reviews:
                      _misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .comments
                          .length,
                  duration:
                      _misRecetas
                          .reduce(
                            (a, b) =>
                                a.averageRating >= b.averageRating ? a : b,
                          )
                          .preparationTime
                          .inMinutes,
                  difficulty:
                      int.tryParse(
                        _misRecetas
                            .reduce(
                              (a, b) =>
                                  a.averageRating >= b.averageRating ? a : b,
                            )
                            .difficulty,
                      ) ??
                      1,
                )
                : const Text("No tienes recetas aún."),
            Text("Mis Recetas", style: theme.textTheme.titleMedium),
            Column(
              children:
                  _misRecetas
                      .take(3) // Mostrar solo las 3 más recientes
                      .map((receta) {
                        print(
                          'DEBUG: Receta -> id: ${receta.id}, name: ${receta.name}, imageUrl: ${receta.imageUrl}, averageRating: ${receta.averageRating}, difficulty: ${receta.difficulty}, preparationTime: ${receta.preparationTime}',
                        );
                        return RecipeCard(
                          id: receta.id,
                          imagePath: receta.imageUrl ?? 'assets/logos/logo.png',
                          title: receta.name,
                          rating: receta.averageRating,
                          reviews: receta.comments.length,
                          duration: receta.preparationTime.inMinutes,
                          difficulty: int.tryParse(receta.difficulty) ?? 1,
                        );
                      })
                      .toList(),
            ),
            VerTodasButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            TodasMisRecetasScreen(recetasUsuario: _misRecetas),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
