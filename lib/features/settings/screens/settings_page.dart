import 'package:flutter/material.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/features/auth/screens/login/login.dart';
import 'package:foody/features/settings/screens/password_security/password_security_screen.dart';
import 'package:foody/features/settings/screens/widgets/profile_tile.dart';
import 'package:foody/features/settings/screens/widgets/settings_section.dart';
import 'package:foody/features/settings/screens/widgets/settings_tile.dart';
import 'package:foody/features/settings/screens/widgets/termsandconditions.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/utils/theme/custom_themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserProfile? _userProfile;
  final ProfileController _profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final email = AuthController().user.correo;
    if (email == null) return;
    await _profileController.loadUserProfile(email);
    setState(() {
      _userProfile = _profileController.userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    if (_userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? CColors.dark : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configuración",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ProfileTile(
                name: _userProfile!.fullName,
                subtitle: 'Ver Perfil',
                avatarUrl: _userProfile!.avatarUrl,
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: "Cuenta",
                tiles: [
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: "Contraseña y Seguridad",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PasswordSecurityScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.exit_to_app,
                    title: "Cerrar Sesión",
                    onTap: () {
                      THelperFunctions.showDialogBox(
                        context,
                        title: 'Cerrar Sesión',
                        content: "¿Estás seguro de que quieres cerrar sesión?",
                        onConfirm: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: "General",
                tiles: [
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: "Tema Oscuro",
                    isSwitch: true,
                    switchValue: themeNotifier.isDarkMode,
                    onChanged: (value) {
                      themeNotifier.toggleTheme(value);
                    },
                  ),
                  const SettingsTile(
                    icon: Icons.notifications_none,
                    title: "Notificaciones y Preferencias",
                  ),
                  const SettingsTile(icon: Icons.language, title: "Idioma"),
                ],
              ),
              SizedBox(height: 16),
              SettingsSection(
                title: "Privacidad",
                tiles: [
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Política de Privacidad",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TermsAndConditionsScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: "Ayuda y Soporte",
                  ),
                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: "Eliminar Cuenta",
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
