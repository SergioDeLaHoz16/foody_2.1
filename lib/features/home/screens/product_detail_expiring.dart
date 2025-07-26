import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/utils/constants/colors.dart';
import 'dart:io';

import 'package:foody/utils/helpers/helper_functions.dart';

class ProductDetailExpiringScreen extends StatelessWidget {
  final Product product;

  const ProductDetailExpiringScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final daysToExpire = product.expiryDate.difference(DateTime.now()).inDays;
    final status =
        daysToExpire < 0
            ? 'Vencido'
            : daysToExpire == 0
            ? 'Hoy'
            : 'Expira en $daysToExpire días';

    final statusColor = _getExpirationColor(status);

    return Scaffold(
      backgroundColor: isDark ? CColors.dark : CColors.light,
      appBar: AppBar(
        title: Text(
          'Detalle del Producto',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: statusColor,
        foregroundColor: isDark ? Colors.white : Colors.black,
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.primaryTextColor,
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Imagen destacada
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(product.photoUrl),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Nombre y estado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? CColors.light
                                      : CColors.primaryTextColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Tarjetas de información
                    _buildInfoCardGrid([
                      _infoCard(
                        context: context,
                        icon: Icons.category,
                        label: 'Categoría',
                        value: product.category,
                      ),
                      _infoCard(
                        context: context,
                        icon: Icons.inventory_2,
                        label: 'Cantidad',
                        value: '${product.quantity}',
                      ),
                      if (product.grams != null)
                        _infoCard(
                          context: context,
                          icon: Icons.scale,
                          label: 'Gramos',
                          value: '${product.grams}',
                        ),
                      _infoCard(
                        context: context,
                        icon: Icons.calendar_today,
                        label: 'Ingreso',
                        value: _formatDate(product.entryDate),
                      ),
                      _infoCard(
                        context: context,
                        icon: Icons.event,
                        label: 'Expira',
                        value: _formatDate(product.expiryDate),
                      ),
                    ]),

                    const SizedBox(height: 18),
                    // Notas
                    if (product.notes != null && product.notes!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? CColors.darkContainer
                                  : Colors.yellow[50],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color:
                                isDark ? Colors.grey.shade700 : Colors.yellow,
                            width: 1,
                          ),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.sticky_note_2,
                              color:
                                  isDark ? CColors.light : Colors.yellow[700],
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                product.notes!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      isDark
                                          ? CColors.light
                                          : Colors.yellow[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCardGrid(List<Widget> cards) {
    List<Widget> rows = [];

    for (int i = 0; i < cards.length; i += 2) {
      final firstCard = Expanded(child: cards[i]);
      final secondCard =
          (i + 1 < cards.length)
              ? Expanded(child: cards[i + 1])
              : const Expanded(child: SizedBox());

      rows.add(
        Row(children: [firstCard, const SizedBox(width: 8), secondCard]),
      );

      rows.add(const SizedBox(height: 8)); // Espaciado entre filas
    }

    return Column(children: rows);
  }

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            (isDark ? CColors.darkContainer : CColors.lightContainer) ??
            Colors.white,

        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey[700], size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? CColors.textCategory : CColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? CColors.light : CColors.primaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        'assets/images/1.png',
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/1.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.file(
        File(imagePath),
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/1.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _getExpirationColor(String status) {
    if (status.contains('Vencido')) {
      return Colors.red;
    } else if (status.contains('Hoy')) {
      return Colors.orange;
    } else if (status.contains('Expira en')) {
      return Colors.green;
    }
    return Colors.grey;
  }
}
