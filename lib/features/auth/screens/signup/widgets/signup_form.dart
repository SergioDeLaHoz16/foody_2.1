import 'package:flutter/material.dart';
import 'package:foody/common/widgets/button.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // if (!isFirstPage)
              //   Expanded(
              //     child: WButton(label: 'Atrás', onPressed: _previousPage),
              //   ),
              if (!isFirstPage) const SizedBox(width: 12),
              Expanded(
                child: WButton(
                  label: isLastPage ? 'Finalizar' : 'Siguiente',
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
