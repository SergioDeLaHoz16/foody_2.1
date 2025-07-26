// lib/features/profile/models/user_profile_model.dart

import 'package:foody/features/auth/models/models.dart';

/// UserProfile extiende UserModel e incluye estadísticas y atributos de UI
class UserProfile extends UserModel {
  /// Nombre de usuario (nickname)
  final String username;

  /// Biografía corta
  final String bio;

  /// Ruta al avatar del usuario
  final String avatarUrl;

  /// Estadísticas de perfil
  final int recetas;
  final double vistas;
  final double seguidores;
  final int resenas;
  final String status;

  UserProfile({
    // Campos heredados de UserModel
    String? nombre,
    String? apellido,
    String? celular,
    String? cedula,
    DateTime? fechaNacimiento,
    String? correo,
    String? pais,
    String? departamento,
    String? municipio,
    String? direccion,
    String? barrio,
    String? contrasena,

    // Campos de UI y estadísticas
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.recetas,
    required this.vistas,
    required this.seguidores,
    required this.resenas,
    required this.status,
  }) : super(
         nombre: nombre,
         apellido: apellido,
         celular: celular,
         cedula: cedula,
         fechaNacimiento: fechaNacimiento,
         correo: correo,
         pais: pais,
         departamento: departamento,
         municipio: municipio,
         direccion: direccion,
         barrio: barrio,
         contrasena: contrasena,
       );

  /// Nombre completo del usuario
  String get fullName => '${nombre ?? ''} ${apellido ?? ''}';
}
