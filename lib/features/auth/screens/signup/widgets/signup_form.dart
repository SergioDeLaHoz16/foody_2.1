import 'package:flutter/material.dart';
import 'package:foody/common/widgets/button.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/auth/controllers/controllers_auth.dart';
import 'package:foody/features/auth/screens/signup/widgets/personal_info_section.dart';
import 'package:foody/features/auth/screens/signup/widgets/email_password_section.dart';
import 'package:foody/features/auth/screens/signup/widgets/address_section.dart';
import 'package:foody/features/auth/screens/signup/widgets/terms_and_submit_section.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _acceptTerms = false;

  List<Widget> get _pages => [
    PersonalInfoSection(pageController: _pageController),
    EmailPasswordSection(pageController: _pageController),
    AddressSection(pageController: _pageController),
    TermsAndSubmitSection(
      pageController: _pageController,
      acceptTerms: _acceptTerms,
      onTermsChanged: (value) => setState(() => _acceptTerms = value ?? false),
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      setState(() => _currentIndex++);
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> _validateForm() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return false;
    }
    form.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _pages.length - 1;
    final isFirstPage = _currentIndex == 0;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:
                isFirstPage
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: WButton(
                            label: 'Siguiente',
                            onPressed: _nextPage,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: WButton(
                            label: isLastPage ? 'Finalizar' : 'Siguiente',
                            onPressed: () async {
                              if (await _validateForm()) {
                                if (isLastPage) {
                                  if (_acceptTerms) {
                                    final success =
                                        await authController.registerUser();

                                    if (!mounted) return;

                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Registro exitoso'),
                                        ),
                                      );
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/home');
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Faltan campos o hubo un error',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Debe aceptar los términos y condiciones',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  _nextPage();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
