import 'package:flutter/material.dart';
import 'package:foody/features/inventory/screens/register_product_screen.dart';
import 'package:foody/features/recipes/screen/register/register.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/constants/images_strings.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'blurred_background.dart';
import 'animated_action_item.dart';

class FloatingMenuButton extends StatefulWidget {
  final VoidCallback? onRefresh;

  const FloatingMenuButton({super.key, this.onRefresh});

  @override
  State<FloatingMenuButton> createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton> {
  bool isOpen = false;
  List<bool> showButtons = [false, false];

  void toggleMenu() async {
    if (isOpen) {
      setState(() => showButtons = [false, false]);
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => isOpen = false);
    } else {
      setState(() => isOpen = true);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => showButtons[0] = true);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => showButtons[1] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    final Color iconColor = Colors.white;

    return Stack(
      children: [
        if (isOpen) BlurredBackground(onTap: toggleMenu),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedActionItem(
                visible: showButtons[0],
                label: "Registrar Receta",
                icon: Image.asset(CImages.recipeIcons, height: 24, width: 24),
                color: isDark ? CColors.darkContainer! : CColors.primaryColor,
                onPressed: () {
                  // Navigate to register recipe screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterRecipeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              AnimatedActionItem(
                visible: showButtons[1],
                label: "Registrar Producto",
                icon: Image.asset(CImages.productIcons, height: 24, width: 24),
                color: isDark ? CColors.darkContainer! : CColors.primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterProductScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: () {
                  toggleMenu();
                  widget.onRefresh?.call();
                },
                backgroundColor:
                    isDark ? CColors.darkContainer! : CColors.primaryColor,
                child: Icon(isOpen ? Icons.close : Icons.add, color: iconColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
