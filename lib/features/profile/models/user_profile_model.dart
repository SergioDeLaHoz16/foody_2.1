// lib/features/profile/models/user_profile_model.dart

import 'package:foody/features/auth/models/models.dart';

/// UserProfile extiende UserModel e incluye estadísticas y atributos de UI
class UserProfile extends UserModel {
  /// Nombre de usuario (nickname)
  final String username;

  /// Biografía corta
  @override
  final String bio;

  /// Ruta al avatar del usuario
  @override
  final String avatarUrl;

  /// Estadísticas de perfil
  @override
  final int recetas;
  @override
  final double vistas;
  @override
  final double seguidores;
  final int resenas;
  @override
  final String status;

  UserProfile({
    // Campos heredados de UserModel
    super.nombre,
    super.apellido,
    super.celular,
    super.cedula,
    super.fechaNacimiento,
    super.correo,
    super.pais,
    super.departamento,
    super.municipio,
    super.direccion,
    super.barrio,
    super.contrasena,

    // Campos de UI y estadísticas
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.recetas,
    required this.vistas,
    required this.seguidores,
    required this.resenas,
    required this.status,
  });

  /// Nombre completo del usuario
  @override
  String get fullName => '${nombre ?? ''} ${apellido ?? ''}';
}
