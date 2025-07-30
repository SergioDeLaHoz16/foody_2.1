import 'package:flutter/material.dart';
import 'package:foody/features/auth/models/models.dart';
import 'package:foody/data/services/auth_service.dart';
import 'package:foody/data/services/google_auth_service.dart';
import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/navigation/navigation.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  final AuthService _authService = AuthService();
  final UserModel _user = UserModel();
  UserModel get user => _user;

  void updateUserField(String field, dynamic value) {
    switch (field) {
      case 'nombre':
        _user.nombre = value;
        break;
      case 'apellido':
        _user.apellido = value;
        break;
      case 'celular':
        _user.celular = value;
        break;
      case 'cedula':
        _user.cedula = value;
        break;
      case 'fechaNacimiento':
        _user.fechaNacimiento = value;
        break;
      case 'correo':
        _user.correo = value;
        break;
      case 'pais':
        _user.pais = value;
        break;
      case 'departamento':
        _user.departamento = value;
        break;
      case 'municipio':
        _user.municipio = value;
        break;
      case 'direccion':
        _user.direccion = value;
        break;
      case 'barrio':
        _user.barrio = value;
        break;
      case 'contrasena':
        _user.contrasena = value;
        break;
    }
  }

  List<String> getMissingFields() {
    List<String> missingFields = [];
    if (_user.nombre == null || _user.nombre!.isEmpty) {
      missingFields.add('Nombre');
    }
    if (_user.apellido == null || _user.apellido!.isEmpty) {
      missingFields.add('Apellido');
    }
    if (_user.celular == null || _user.celular!.isEmpty) {
      missingFields.add('Número de Celular');
    }
    if (_user.cedula == null || _user.cedula!.isEmpty) {
      missingFields.add('Número de Cédula');
    }
    if (_user.fechaNacimiento == null) missingFields.add('Fecha de Nacimiento');
    if (_user.correo == null || _user.correo!.isEmpty) {
      missingFields.add('Correo Electrónico');
    }
    if (_user.pais == null || _user.pais!.isEmpty) missingFields.add('País');
    if (_user.departamento == null || _user.departamento!.isEmpty) {
      missingFields.add('Departamento');
    }
    if (_user.municipio == null || _user.municipio!.isEmpty) {
      missingFields.add('Municipio');
    }
    if (_user.direccion == null || _user.direccion!.isEmpty) {
      missingFields.add('Dirección');
    }
    if (_user.barrio == null || _user.barrio!.isEmpty) {
      missingFields.add('Barrio');
    }
    if (_user.contrasena == null || _user.contrasena!.isEmpty) {
      missingFields.add('Contraseña');
    }
    return missingFields;
  }

  Future<bool> registerUser() async {
    List<String> missingFields = getMissingFields();

    if (missingFields.isNotEmpty) {
      // Faltan campos
      print('Faltan los siguientes campos: ${missingFields.join(', ')}');
      return false;
    }

    final success = await _authService.createUser(_user);
    if (success) {
      print('Usuario registrado exitosamente');
      return true;
    } else {
      print('Error al registrar usuario');
      return false;
    }
  }

  Future<bool> isCedulaDuplicated(String cedula) async {
    return await _authService.isCedulaDuplicated(cedula);
  }

  Future<bool> isEmailDuplicated(String email) async {
    return await _authService.isEmailDuplicated(email);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final googleUser = await GoogleAuthService.signInWithGoogle();
    if (googleUser != null) {
      final email = googleUser.email;
      final name = googleUser.displayName ?? 'Usuario';

      // Verificar si el usuario ya existe en MongoDB
      final collection = MongoDBHelper.db.collection('users');
      final existingUser = await collection.findOne({'correo': email});

      if (existingUser == null) {
        // Si el usuario no existe, crearlo en MongoDB
        final defaultFechaNacimiento = DateTime(2002, 2, 1);
        final newUser = UserModel(
          nombre: name,
          correo: email,
          contrasena: '',
          fechaNacimiento: defaultFechaNacimiento,
        );
        await collection.insert(newUser.toJson());
        print('Usuario creado en MongoDB: $name');

        // Actualizar el modelo _user con los datos del nuevo usuario
        _user.nombre = name;
        _user.correo = email;
        _user.fechaNacimiento = defaultFechaNacimiento;
      } else {
        print('Usuario ya existe en MongoDB: $name');

        // Actualizar el modelo _user con los datos del usuario existente
        _user.nombre = existingUser['nombre'];
        _user.apellido = existingUser['apellido'];
        _user.correo = existingUser['correo'];
        _user.celular = existingUser['celular'];
        _user.cedula = existingUser['cedula'];
        _user.fechaNacimiento =
            existingUser['fechaNacimiento'] != null
                ? DateTime.parse(existingUser['fechaNacimiento'])
                : DateTime(2002, 2, 1);
        _user.pais = existingUser['pais'];
        _user.departamento = existingUser['departamento'];
        _user.municipio = existingUser['municipio'];
        _user.direccion = existingUser['direccion'];
        _user.barrio = existingUser['barrio'];
        _user.contrasena = existingUser['contrasena'];
        _user.status = existingUser['status'] ?? 'FREE'; // <-- AQUÍ
      }

      // Navegar a la pantalla principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }

  Future<void> signOut() async {
    await GoogleAuthService.signOut();
    print('Sesión cerrada');
  }

  Future<void> updateStatus(String status) async {
    final collection = MongoDBHelper.db.collection('users');
    await collection.updateOne(
      {'correo': _user.correo},
      {
        '\$set': {'status': status},
      },
    );
    _user.status = status;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final user = await collection.findOne({
        'correo': email,
        'contrasena':
            password, // Asegúrate de cifrar las contraseñas en la base de datos
      });

      if (user != null) {
        print('Usuario autenticado: ${user['nombre']}');

        // Actualizar el modelo _user con los datos del usuario autenticado
        _user.nombre = user['nombre'];
        _user.apellido = user['apellido'];
        _user.correo = user['correo'];
        _user.celular = user['celular'];
        _user.cedula = user['cedula'];
        _user.fechaNacimiento = DateTime.parse(user['fechaNacimiento']);
        _user.pais = user['pais'];
        _user.departamento = user['departamento'];
        _user.municipio = user['municipio'];
        _user.direccion = user['direccion'];
        _user.barrio = user['barrio'];
        _user.contrasena = user['contrasena'];
        _user.status = user['status'] ?? 'FREE'; // <-- AQUÍ
        print('Correo asignado al modelo _user: ${_user.correo}');
        return true;
      } else {
        print('Credenciales incorrectas');
        return false;
      }
    } catch (e) {
      print('Error al autenticar usuario: $e');
      return false;
    }
  }

  /// Actualiza la contraseña de un usuario por correo electrónico.
  Future<bool> updatePassword(String email, String newPassword) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final result = await collection.updateOne(
        {'correo': email},
        {
          '\$set': {'contrasena': newPassword},
        },
      );
      if (result.isSuccess) {
        // Opcional: actualiza el modelo local si corresponde
        if (_user.correo == email) {
          _user.contrasena = newPassword;
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error al actualizar la contraseña: $e');
      return false;
    }
  }

  Future<void> reloadUser() async {
    final collection = MongoDBHelper.db.collection('users');
    final user = await collection.findOne({'correo': _user.correo});
    if (user != null) {
      _user.nombre = user['nombre'];
      _user.apellido = user['apellido'];
      _user.correo = user['correo'];
      _user.celular = user['celular'];
      _user.cedula = user['cedula'];
      _user.fechaNacimiento =
          user['fechaNacimiento'] != null
              ? DateTime.parse(user['fechaNacimiento'])
              : null;
      _user.pais = user['pais'];
      _user.departamento = user['departamento'];
      _user.municipio = user['municipio'];
      _user.direccion = user['direccion'];
      _user.barrio = user['barrio'];
      _user.contrasena = user['contrasena'];
      _user.status = user['status'] ?? 'FREE';
    }
  }
}
