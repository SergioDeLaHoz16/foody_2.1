import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class SectionLayout extends StatelessWidget {
  final String sectionTitle;
  final String? sectionSubtitle;
  final Widget child;

  const SectionLayout({
    super.key,
    required this.sectionTitle,
    required this.sectionSubtitle,
    required this.child,
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
          // Botón de retroceso en la esquina superior izquierda
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: isDark ? CColors.light : CColors.primaryTextColor,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          const SizedBox(height: 8),

          // Contenido central alineado
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(logoAsset, height: 100),
                  const SizedBox(height: 20),
                  Text(
                    'Registro',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: isDark ? CColors.light : CColors.primaryColor,
                    ),
                  ),
                  Text(
                    'Section - $sectionTitle',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? CColors.light : CColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
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

          // Sección del contenido dinámico (formulario)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ],
      ),
    );
  }
}
