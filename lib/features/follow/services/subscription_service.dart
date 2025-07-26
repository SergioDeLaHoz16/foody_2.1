import 'package:foody/data/repositories/mongodb_helper.dart';
import '../../profile/models/user_profile_model.dart';
import '../../recipes/models/models.dart';
import '../../recipes/services/recipe_service.dart';

class SubscriptionService {
  Future<bool> checkIfSubscribed(String correo) async {
    // Aquí va la lógica real con MongoDB o cache
    await Future.delayed(const Duration(milliseconds: 500));
    return false;
  }

  Future<void> subscribe(String correo, String status) async {
    final collection = MongoDBHelper.db.collection('users');
    await collection.updateOne(
      {'correo': correo},
      {
        '\$set': {'status': status},
      },
    );
  }

  Future<UserProfile> fetchUserProfile(String correo) async {
    final collection = MongoDBHelper.db.collection('users');
    final userData = await collection.findOne({'correo': correo});
    if (userData == null) {
      throw Exception('Usuario no encontrado');
    }
    return UserProfile(
      nombre: userData['nombre'] ?? '',
      apellido: userData['apellido'] ?? '',
      celular: userData['celular'] ?? '',
      cedula: userData['cedula'] ?? '',
      fechaNacimiento:
          userData['fechaNacimiento'] != null
              ? DateTime.parse(userData['fechaNacimiento'])
              : null,
      correo: userData['correo'] ?? '',
      pais: userData['pais'] ?? '',
      departamento: userData['departamento'] ?? '',
      municipio: userData['municipio'] ?? '',
      direccion: userData['direccion'] ?? '',
      barrio: userData['barrio'] ?? '',
      contrasena: userData['contrasena'] ?? '',
      username: userData['correo'] ?? '',
      bio: userData['bio'] ?? '',
      avatarUrl: userData['avatarUrl'] ?? 'assets/icons/avatar.png',
      recetas: userData['recetas'] ?? 0,
      vistas: userData['vistas']?.toDouble() ?? 0,
      seguidores: userData['seguidores']?.toDouble() ?? 0,
      resenas: userData['resenas'] ?? 0,
      status: userData['status'] ?? 'Free',
    );
  }

  Future<List<Recipe>> fetchUserRecipes(String correo) async {
    final recipeService = RecipeService();
    final todasLasRecetas = await recipeService.fetchRecipes();
    return todasLasRecetas
        .where((receta) => receta.createdBy == correo)
        .toList();
  }
}
