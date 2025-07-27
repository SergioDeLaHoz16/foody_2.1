import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class SectionLayout extends StatelessWidget {
  final String sectionTitle;
  final String? sectionSubtitle;
  final Widget child;
  final PageController? pageController;

  const SectionLayout({
    super.key,
    required this.sectionTitle,
    required this.sectionSubtitle,
    required this.child,
    this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);

    final logoAsset =
        isDark ? 'assets/logos/logo3.png' : 'assets/logos/logoFinal.png';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: isDark ? CColors.light : CColors.primaryTextColor,
              onPressed: () {
                if (pageController != null &&
                    pageController!.hasClients &&
                    pageController!.page! > 0) {
                  pageController!.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(logoAsset, height: 100),
                  const SizedBox(height: 25),
                  Text(
                    'Registro',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: isDark ? CColors.light : CColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Seccion - $sectionTitle',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? CColors.light : CColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    sectionSubtitle ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ],
      ),
    );
  }
}
