import 'package:flutter/material.dart';
import 'package:foody/features/follow/screens/subscribed_recipes_page.dart';
import 'package:foody/features/follow/widgets/profile_header_follow.dart';
import 'package:foody/features/follow/widgets/subscription_button.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/features/profile/screen/widgets/profile_stats.dart';
import 'package:foody/features/follow/services/subscription_service.dart';
import 'package:foody/features/profile/screen/widgets/popular_recipe_card.dart';
import 'package:foody/features/profile/screen/widgets/ver_todas_button.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/follow/screens/subscription_page.dart';
import 'package:foody/features/follow/controllers/subscription_controller.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class ProfileSubscriptionPage extends StatefulWidget {
  final String correo;
  final String nombre;
  final String apellido;
  final String avatarUrl;

  const ProfileSubscriptionPage({
    super.key,
    required this.correo,
    required this.nombre,
    required this.apellido,
    required this.avatarUrl,
  });

  @override
  State<ProfileSubscriptionPage> createState() =>
      _ProfileSubscriptionPageState();
}

class _ProfileSubscriptionPageState extends State<ProfileSubscriptionPage> {
  final SubscriptionController subscriptionController =
      SubscriptionController();
  final AuthController authController = AuthController();
  int selectedTabIndex = 0;
  late Future<UserProfile> _userProfileFuture;
  late Future<List<Recipe>> _userRecipesFuture;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = SubscriptionService().fetchUserProfile(widget.correo);
    _userRecipesFuture = SubscriptionService().fetchUserRecipes(widget.correo);

    // Usa el controlador para cargar el estado de suscripción
    subscriptionController.loadUserProfile(widget.correo);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _userProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No se pudo cargar el perfil'));
        }
        final userProfile = snapshot.data!;
        final isDark = THelperFunctions.isDarkMode(context);
        final theme = Theme.of(context);
        final size = MediaQuery.of(context).size;
        final isSmallScreen = size.width < 360;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? CColors.dark : Colors.white,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            elevation: 2,
            toolbarHeight: 38,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(user: userProfile),
                const SizedBox(height: 60),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 0,
                  ),
                  child: ProfileStats(user: userProfile),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: SizedBox(
                    width: double.infinity,
                    child: StyledSubscriptionButton(
                      isSubscribed:
                          authController.user.status?.toUpperCase() ==
                          "SUSCRITO",
                      onPressed:
                          authController.user.status?.toUpperCase() ==
                                  "SUSCRITO"
                              ? null
                              : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SubscriptionPage(),
                                  ),
                                );
                                // Si el usuario se suscribió, recarga el usuario y actualiza el estado
                                if (result == true) {
                                  await authController.reloadUser();
                                  if (mounted) setState(() {});
                                }
                              },
                    ),
                  ),
                ),

                if (authController.user.status?.toUpperCase() == "SUSCRITO")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text(
                                    "¿Estás seguro de cancelar tu suscripción?",
                                  ),
                                  content: const Text(
                                    "Perderás acceso a las recetas exclusivas.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text("Cancelar"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text("Aceptar"),
                                    ),
                                  ],
                                ),
                          );
                          if (confirmed == true) {
                            await authController.updateStatus("FREE");
                            // Recarga el usuario desde la base de datos
                            await authController.reloadUser();
                            if (mounted) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Suscripción cancelada."),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Cancelar Suscripción"),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    _buildTabButton("Mi Contenido", 0),
                    const SizedBox(width: 16),
                    _buildTabButton("Acerca de mí", 1),
                  ],
                ),

                const SizedBox(height: 24),

                if (selectedTabIndex == 0) ...[
                  Text(
                    "Receta más popular",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Recipe>>(
                    future: _userRecipesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No hay recetas publicadas.");
                      }
                      // Encuentra la receta con mayor rating
                      final recetas = snapshot.data!;
                      final recetaPopular = recetas.reduce(
                        (a, b) => a.averageRating >= b.averageRating ? a : b,
                      );

                      return PopularRecipeCard(
                        id: recetaPopular.id,
                        imagePath:
                            recetaPopular.imageUrl ?? 'assets/logos/logo.png',
                        title: recetaPopular.name,
                        rating: recetaPopular.averageRating,
                        reviews: 0,
                        duration: recetaPopular.preparationTime.inMinutes,
                        difficulty: _parseDifficulty(recetaPopular.difficulty),
                      );
                    },
                  ),
                  VerTodasButton(
                    onTap: () async {
                      final recetas = await _userRecipesFuture;
                      final recetasPublicas =
                          recetas.where((r) => !r.isPrivate).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => TodasMisRecetasScreen(
                                recetasUsuario: recetasPublicas,
                              ),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  UserInfoCard(
                    nombre: "${userProfile.nombre} ${userProfile.apellido}",
                    email: userProfile.correo ?? '',
                    telefono: userProfile.celular ?? '',
                    ubicacion: userProfile.pais ?? '',
                    fechaRegistro:
                        userProfile.fechaNacimiento != null
                            ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(userProfile.fechaNacimiento!)
                            : '',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Trayectoria:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Más de 8 años como chef profesional. Especialista en platos vegetarianos y sin gluten.",
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected) Container(height: 2, width: 60, color: Colors.green),
        ],
      ),
    );
  }

  int _parseDifficulty(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return 1;
      case 'media':
        return 2;
      case 'difícil':
      case 'dificil':
        return 3;
      default:
        return int.tryParse(difficulty ?? '') ?? 1;
    }
  }
}

// NUEVO WIDGET
class UserInfoCard extends StatelessWidget {
  final String nombre;
  final String email;
  final String telefono;
  final String ubicacion;
  final String fechaRegistro;

  const UserInfoCard({
    super.key,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.ubicacion,
    required this.fechaRegistro,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacion',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow("Nombre:", nombre),
          _buildInfoRow("Email:", email),
          _buildInfoRow("Telefono:", telefono),
          _buildInfoRow("Ubicacion:", ubicacion),
          _buildInfoRow("Registro:", fechaRegistro),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
