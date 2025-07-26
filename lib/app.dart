import 'package:flutter/material.dart';
import 'package:foody/features/auth/screens/login/login.dart';
import 'package:foody/features/auth/screens/signup/signup_page.dart';
// import 'package:foody/features/auth/screens/signup/signup_page_1.dart';
import 'package:foody/features/navigation/navigation.dart';
import 'package:foody/features/settings/screens/password_security/change_password/change_password_screen.dart';
import 'package:foody/features/settings/screens/password_security/password_security_screen.dart';
import 'package:foody/features/settings/screens/settings_page.dart';
import 'package:foody/utils/theme/custom_themes/theme_notifier.dart';
import 'package:foody/utils/theme/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return AnimatedTheme(
      data:
          themeNotifier.isDarkMode ? TAppTheme.darkTheme : TAppTheme.lightTheme,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linearToEaseOut,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foody',
        theme:
            themeNotifier.isDarkMode
                ? TAppTheme.darkTheme
                : TAppTheme.lightTheme,
        home: const LoginScreen(),
        routes: {
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const NavigationScreen(),
          '/settings': (context) => const SettingsPage(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/password-security': (context) => const PasswordSecurityScreen(),
        },
      ),
    );
  }
}
