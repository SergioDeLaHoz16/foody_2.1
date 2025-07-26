import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';

class ProductsExpiringSoonPage extends StatelessWidget {
  final List<Product> products;

  const ProductsExpiringSoonPage({Key? key, required this.products})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos por caducar')),
      body:
          products.isEmpty
              ? const Center(
                child: Text('No hay productos próximos a caducar.'),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final days =
                      product.expiryDate.difference(DateTime.now()).inDays;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          (product.photoUrl != null &&
                                  product.photoUrl!.isNotEmpty)
                              ? NetworkImage(product.photoUrl!)
                              : const AssetImage('assets/images/1.png')
                                  as ImageProvider,
                    ),
                    title: Text(product.name),
                    subtitle: Text(
                      days < 0
                          ? 'Vencido'
                          : days == 0
                          ? 'Caduca hoy'
                          : 'Caduca en $days día(s)',
                      style: TextStyle(
                        color:
                            days < 0
                                ? Colors.red
                                : days == 0
                                ? Colors.orange
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text('Cantidad: ${product.quantity}'),
                  );
                },
              ),
    );
  }
}
