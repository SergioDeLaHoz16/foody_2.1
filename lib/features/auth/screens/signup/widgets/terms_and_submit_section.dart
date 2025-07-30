import 'package:flutter/material.dart';
import 'package:foody/features/auth/widgets/section_layout.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/common/widgets/button.dart';

class TermsAndSubmitSection extends StatelessWidget {
  final PageController pageController;
  final bool acceptTerms;
  final ValueChanged<bool?> onTermsChanged;

  const TermsAndSubmitSection({
    super.key,
    required this.pageController,
    required this.acceptTerms,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);

    return SectionLayout(
      sectionTitle: 'Términos y condiciones',
      sectionSubtitle:
          'Antes de crear tu cuenta, por favor lee y acepta nuestros términos y condiciones.',
      pageController: pageController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? CColors.dark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  '1. Uso de la app\nAl utilizar esta aplicación, certificas que has leído y aceptado los términos...\n\n'
                  '2. Política de privacidad\nRevisamos cómo usamos y almacenamos tus datos...\n\n'
                  '3. Propiedad intelectual\nTodos los derechos están reservados por Foody...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.6,
                    color: isDark ? CColors.light : CColors.dark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: acceptTerms,
            onChanged: onTermsChanged,
            title: const Text('Acepto los términos y condiciones'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: WButton(
                  label: 'Declinar',
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CColors.borderError,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
