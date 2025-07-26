import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';

class ProductDetailsWidget extends StatelessWidget {
  final Product product;

  const ProductDetailsWidget({super.key, required this.product});

  bool _isValidNetworkUrl(String? url) {
    return url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return AlertDialog(
      backgroundColor: isDark ? CColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textAlign: TextAlign.center,
            product.name.isNotEmpty ? product.name : 'Producto sin nombre',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: CColors.secondaryButton,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            child: Icon(Icons.close, color: CColors.secondaryButton, size: 24),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isValidNetworkUrl(product.photoUrl))
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.photoUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 150);
                  },
                ),
              )
            else
              const Icon(Icons.fastfood, size: 150),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Categoría: ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.category.isNotEmpty ? product.category : 'Sin categoría'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cantidad total: ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.quantity}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (product.notes != null && product.notes!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Notas: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${product.notes}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            else
              const Text(
                'Notas: No hay notas disponibles',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _showStockDetails(context),
              style: TextButton.styleFrom(
                backgroundColor: CColors.primaryButton,
                foregroundColor: CColors.secondaryButton,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              child: const Text('Ver detalles de stock'),
            ),
          ],
        ),
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () => Navigator.pop(context),
      //     style: TextButton.styleFrom(
      //       backgroundColor: CColors.primaryButton,
      //       foregroundColor: CColors.secondaryButton,
      //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //     ),
      //     child: const Text('Cerrar'),
      //   ),
      // ],
    );
  }

  void _showStockDetails(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? CColors.darkContainer : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Detalles: ${product.name}'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: CColors.secondaryButton,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    color: CColors.secondaryButton,
                    size: 24,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Mostrar la entrada principal
                  _StockCard(
                    entryDate: product.entryDate,
                    expiryDate: product.expiryDate,
                    quantity: product.quantity,
                    grams: product.grams,
                  ),
                  // Mostrar las entradas adicionales
                  ...product.entradas.map((entry) {
                    return _StockCard(
                      entryDate: entry.entryDate,
                      expiryDate: entry.expiryDate,
                      quantity: entry.quantity,
                      grams: entry.grams,
                    );
                  }).toList(),
                ],
              ),
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.pop(context),
            //     child: const Text('Cerrar'),
            //   ),
            // ],
          ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final DateTime entryDate;
  final DateTime expiryDate;
  final int quantity;
  final double? grams;

  const _StockCard({
    required this.entryDate,
    required this.expiryDate,
    required this.quantity,
    this.grams,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    final remainingTime = expiryDate.difference(DateTime.now());
    final remainingText =
        remainingTime.isNegative
            ? 'Expirado'
            : '${remainingTime.inDays} días ${remainingTime.inHours % 24}h';

    return Card(
      color: isDark ? CColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Fecha de ingreso: ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${DateFormat.yMMMMd().format(entryDate)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Fecha de caducidad: ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '${DateFormat.yMMMMd().format(expiryDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Cantidad: ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('$quantity', style: const TextStyle(fontSize: 12)),
              ],
            ),
            if (grams != null)
              Row(
                children: [
                  Text(
                    'Gramos: ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('$grams', style: const TextStyle(fontSize: 12)),
                ],
              ),
            Row(
              children: [
                Text(
                  'Tiempo restante: ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('$remainingText', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
