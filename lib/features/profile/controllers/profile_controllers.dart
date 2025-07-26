import 'package:foody/features/auth/models/models.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/recipes/models/models.dart';

class ProfileController {
  UserProfile? userProfile;

  // Nuevo método para obtener recetas del usuario
  Future<List<Recipe>> fetchUserRecipes(String email) async {
    final recipeService = RecipeService();
    final todasLasRecetas = await recipeService.fetchRecipes();
    return todasLasRecetas
        .where((receta) => receta.createdBy == email)
        .toList();
  }

  /// Carga los datos del usuario desde la base de datos
  Future<void> loadUserProfile(String email) async {
    if (email.isEmpty) {
      print('El correo está vacío. No se puede cargar el perfil.');
      return;
    }

    try {
      final collection = MongoDBHelper.db.collection('users');
      final userData = await collection.findOne({'correo': email});

      if (userData != null) {
        userProfile = UserProfile(
          nombre: userData['nombre'] ?? 'Nombre no disponible',
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
          username: userData['correo'] ?? 'Usuario',
          bio: userData['bio'] ?? 'Sin biografía',
          avatarUrl: userData['avatarUrl'] ?? 'assets/icons/avatar.png',
          recetas: userData['recetas'] ?? 0,
          vistas: userData['vistas'] ?? 0,
          seguidores: userData['seguidores'] ?? 0,
          resenas: userData['resenas'] ?? 0,
          status: userData['status'] ?? 'Free',
        );
      } else {
        print('No se encontraron datos para el usuario con correo: $email');
      }
    } catch (e) {
      print('Error al cargar el perfil del usuario: $e');
    }
  }

  /// Guarda los datos actualizados del usuario en la base de datos
  Future<bool> saveUserProfile(UserModel updatedUser) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      await collection.updateOne(
        {'correo': updatedUser.correo},
        {'\$set': updatedUser.toJson()},
      );
      return true;
    } catch (e) {
      print('Error al guardar el perfil del usuario: $e');
      return false;
    }
  }
}
