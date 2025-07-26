import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/utils/theme/custom_themes/text_field_theme.dart';

class IngredienteCard extends StatelessWidget {
  final String nombre;
  final String cantidad;
  final String unidad;
  final String imagen;

  const IngredienteCard({
    super.key,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final borderColor = CColors.borderPrimary;
    final textColor = dark ? CColors.textBlanco : CColors.primaryTextColor;
    final subTextColor = dark ? Colors.grey.shade400 : Colors.grey.shade600;
    final cardColor =
        dark
            ? TTextFieldTheme.darkInputDecorationTheme.fillColor
            : TTextFieldTheme.lightInputDecorationTheme.fillColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cuadro de cantidad
        Container(
          width: 69,
          height: 72,
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: dark ? Colors.black26 : Colors.grey.shade100,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            cantidad,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
        ),

        // Tarjeta del producto
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                // Imagen del producto
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: AssetImage(imagen),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Nombre y unidad
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unidad,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
