import 'package:foody/features/recipes/models/models.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import '../services/subscription_service.dart';

class SubscriptionController {
  bool isSubscribed = false;
  late UserProfile viewedUser;
  List<Recipe> userRecipes = [];

  Future<void> loadUserProfile(String correo) async {
    viewedUser = await SubscriptionService().fetchUserProfile(correo);
    // Verifica el status directamente del perfil
    isSubscribed = (viewedUser.status.toUpperCase() == "SUSCRITO");
    if (isSubscribed) {
      userRecipes = await SubscriptionService().fetchUserRecipes(correo);
    }
    
  }

  Future<void> subscribeToUser(String correo) async {
    await SubscriptionService().subscribe(correo, "SUSCRITO");
    isSubscribed = true;
    viewedUser = UserProfile(
      nombre: viewedUser.nombre,
      apellido: viewedUser.apellido,
      celular: viewedUser.celular,
      cedula: viewedUser.cedula,
      fechaNacimiento: viewedUser.fechaNacimiento,
      correo: viewedUser.correo,
      pais: viewedUser.pais,
      departamento: viewedUser.departamento,
      municipio: viewedUser.municipio,
      direccion: viewedUser.direccion,
      barrio: viewedUser.barrio,
      contrasena: viewedUser.contrasena,
      username: viewedUser.username,
      bio: viewedUser.bio,
      avatarUrl: viewedUser.avatarUrl,
      recetas: viewedUser.recetas,
      vistas: viewedUser.vistas,
      seguidores: viewedUser.seguidores,
      resenas: viewedUser.resenas,
      status: "FREE",
    );
    userRecipes = await SubscriptionService().fetchUserRecipes(correo);
  }
}
