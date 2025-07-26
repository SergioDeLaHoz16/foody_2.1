import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';

/// Widget que muestra un indicador de dificultad con 3 barras.
/// - level = 1: una barra verde (fácil)
/// - level = 2: dos barras amarillas (medio)
/// - level = 3: tres barras rojas (difícil)
class DifficultyIndicator extends StatelessWidget {
  final int level;

  const DifficultyIndicator({Key? key, required this.level})
    : assert(level >= 1 && level <= 3),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el color según el nivel usando constantes de CColors
    final Color fillColor;
    switch (level) {
      case 1:
        fillColor = CColors.easy;
        break;
      case 2:
        fillColor = CColors.medium;
        break;
      case 3:
      default:
        fillColor = CColors.hard;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final bool isFilled = index < level;
        // Barras no rellenas usan el color de borde primario
        final Color barColor = isFilled ? fillColor : CColors.borderPrimary;
        return Container(
          width: 17,
          height: 16,
          margin: EdgeInsets.only(right: index < 1 ? 0 : 0),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(0),
            ),
          ),
        );
      }),
    );
  }
}
