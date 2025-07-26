import 'package:foody/features/auth/models/models.dart';
import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AuthService {
  Future<bool> createUser(UserModel user) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      await collection.insert(user.toJson());
      return true;
    } catch (e) {
      print('Error al crear usuario: $e');
      return false;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final user = await collection.findOne({
        'correo': email,
        'contrasena': password,
      });
      return user != null;
    } catch (e) {
      print('Error al autenticar usuario: $e');
      return false;
    }
  }

  Future<bool> isCedulaDuplicated(String cedula) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final user = await collection.findOne({'cedula': cedula});
      return user != null;
    } catch (e) {
      print('Error al verificar cédula duplicada: $e');
      return false;
    }
  }

  Future<bool> isEmailDuplicated(String email) async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final user = await collection.findOne({'correo': email});
      return user != null;
    } catch (e) {
      print('Error al verificar correo duplicado: $e');
      return false;
    }
  }

//   Future<bool> sendRecoveryEmail(String email) async {
//     try {
//       final collection = MongoDBHelper.db.collection('users');
//       final user = await collection.findOne({'correo': email});

//       if (user == null) {
//         print('Correo no encontrado en la base de datos');
//         return false;
//       }

//       final smtpServer = gmail('your_email@gmail.com', 'your_email_password');
//       final message =
//           Message()
//             ..from = Address('your_email@gmail.com', 'Gestion Recetas')
//             ..recipients.add(email)
//             ..subject = 'Recuperación de Contraseña'
//             ..text = '''
// Hola ${user['nombre']},

// Hemos recibido una solicitud para recuperar tu contraseña. 
// Tu contraseña actual es: ${user['contrasena']}

// Por favor, inicia sesión con esta contraseña o cámbiala desde tu perfil.

// Si no solicitaste este cambio, ignora este mensaje.

// Saludos,
// El equipo de Gestion Recetas
// ''';

//       await send(message, smtpServer);
//       return true;
//     } catch (e) {
//       print('Error al enviar correo de recuperación: $e');
//       return false;
//     }
//   }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final collection = MongoDBHelper.db.collection('users');
      final users = await collection.find().toList();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<bool> emailExists(String email) async {
    final collection = MongoDBHelper.db.collection('users');
    final user = await collection.findOne({'correo': email});
    return user != null;
  }
}
