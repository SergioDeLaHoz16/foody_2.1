import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    PersonalInfoSection(),
    EmailPasswordSection(),
    AddressSection(),
    TermsAndSubmitSection(),
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

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _pages.length - 1;
    final isFirstPage = _currentIndex == 0;

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isFirstPage)
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text('Atrás'),
                ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(isLastPage ? 'Finalizar' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
