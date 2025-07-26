// lib/features/recipes/screen/register/widgets/product_selection_modal.dart
import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';

class ProductSelectionPage extends StatefulWidget {
  final List<Product> products;
  final List<Product> selectedProducts;
  final Function(List<Product>) onSelected;

  const ProductSelectionPage({
    Key? key,
    required this.products,
    required this.selectedProducts,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<ProductSelectionPage> createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  // Mapa para rastrear la cantidad seleccionada de cada producto
  final Map<String, int> selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    for (var product in widget.selectedProducts) {
      selectedQuantities[product.id] = product.quantity;
    }
  }

  void _updateSelectedProducts(Product product, int quantity) {
    setState(() {
      if (quantity > 0) {
        selectedQuantities[product.id] = quantity;
      } else {
        selectedQuantities.remove(product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Altura del modal
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selecciona los productos',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                final selectedQuantity = selectedQuantities[product.id] ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    leading:
                        product.photoUrl != null
                            ? Image.network(
                              product.photoUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50);
                              },
                            )
                            : const Icon(Icons.fastfood, size: 50),
                    title: Text(product.name),
                    subtitle: Text('Cantidad disponible: ${product.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed:
                              selectedQuantity > 0
                                  ? () {
                                    if (selectedQuantity > 0) {
                                      _updateSelectedProducts(
                                        product,
                                        selectedQuantity - 1,
                                      );
                                    }
                                  }
                                  : null,
                        ),
                        Text(selectedQuantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed:
                              selectedQuantity < product.quantity
                                  ? () {
                                    if (selectedQuantity < product.quantity) {
                                      _updateSelectedProducts(
                                        product,
                                        selectedQuantity + 1,
                                      );
                                    }
                                  }
                                  : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final selectedProducts =
                  widget.products
                      .where(
                        (product) => selectedQuantities[product.id] != null,
                      )
                      .map(
                        (product) => product.copyWith(
                          quantity: selectedQuantities[product.id],
                        ),
                      )
                      .toList();

              widget.onSelected(selectedProducts);
              Navigator.pop(context);
            },
            child: const Text('Agregar Ingredientes'),
          ),
        ],
      ),
    );
  }
}
