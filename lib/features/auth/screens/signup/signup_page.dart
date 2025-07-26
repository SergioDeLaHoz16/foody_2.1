import 'package:flutter/material.dart';
import 'package:foody/features/auth/screens/signup/widgets/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SignUpForm()));
  }
}
