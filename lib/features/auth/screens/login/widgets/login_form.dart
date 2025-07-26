import 'package:flutter/material.dart';
import 'package:foody/common/widgets/button.dart';
import 'package:foody/common/widgets/login/TextDivider.dart';
import 'package:foody/common/widgets/text_button.dart';
import 'package:foody/features/auth/screens/Recover%20password/recover_password.dart';
import 'package:foody/features/auth/screens/signup/signup_page.dart';
import 'package:foody/features/navigation/navigation.dart';
import 'package:foody/utils/constants/images_strings.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/utils/validators/validators.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.dark});

  final bool dark;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _obscureText = true;
  bool _rememberMe = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final success = await _authController.signInWithEmailAndPassword(
        email,
        password,
      );

      if (success) {
    
        if (_authController.user.correo != null &&
            _authController.user.correo!.isNotEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
          );
        } else {
          print(
            'Error: El correo del usuario no está disponible después del inicio de sesión.',
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  void _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Ingrese su correo electrónico',
                  labelText: 'Correo electrónico',
                ),
                validator: VValidators.validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  hintText: 'Ingrese su contraseña',
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: VValidators.validatePassword,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) async {
                          _toggleRememberMe(value);
                          final prefs = await SharedPreferences.getInstance();
                          if (value ?? false) {
                            await prefs.setString(
                              'email',
                              _emailController.text,
                            );
                            await prefs.setString(
                              'password',
                              _passwordController.text,
                            );
                          } else {
                            await prefs.remove('email');
                            await prefs.remove('password');
                          }
                        },
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Text(
                        'Recuérdame',
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  WTextButton(
                    label: 'Olvidaste tu\ncontraseña?',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RecoverPasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              WButton(label: 'Iniciar Sesión', onPressed: _submitForm),

              TextDivider(widget: widget),

              WButton(
                label: 'Iniciar Sesión con Google',
                icon: Image.asset(CImages.googleLogo, height: 24, width: 24),
                isGoogleButton: true,
                onPressed: () async {
                  await _authController.signInWithGoogle(context);
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'No tienes cuenta?',
                    style: TextStyle(fontSize: 15),
                  ),
                  WTextButton(
                    label: 'Regístrate Aquí',
                    onPressed: () {
                      THelperFunctions.navigateToScreen(context, SignUpPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
