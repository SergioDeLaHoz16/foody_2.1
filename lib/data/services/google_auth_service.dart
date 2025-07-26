import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Inicia sesión con Google
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Usuario autenticado: ${account.displayName}');
        print('Correo electrónico: ${account.email}');
        return account;
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
    }
    return null;
  }

  // Cierra sesión
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    print('Sesión cerrada');
  }
}