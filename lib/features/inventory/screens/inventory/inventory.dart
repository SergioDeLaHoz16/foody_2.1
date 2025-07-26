import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/inventory/screens/inventory/widgets/ProductDetailsWidget.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/utils/constants/categories.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/features/inventory/screens/inventory/used_products_history_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryService _inventoryService = InventoryService();
  late Future<List<Product>> _productsFuture;
  String _selectedCategory = 'Todos';
  bool _isExpanded = false;
  final Set<int> _expandedIndexes = {};

  @override
  void initState() {
    super.initState();
    _productsFuture = _inventoryService.fetchProducts();
  }

  bool _isValidNetworkUrl(String? url) {
    return url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = AuthController().user.correo ?? '';
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? CColors.light : CColors.primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver historial de productos usados',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UsedProductsHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar el inventario: ${snapshot.error}',
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos en el inventario.'),
                  );
                } else {
                  final products =
                      snapshot.data!
                          .where(
                            (product) =>
                                product.createdBy == userEmail &&
                                (_selectedCategory == 'Todos' ||
                                    product.category == _selectedCategory),
                          )
                          .toList();
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product, index);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            ProductCategories.all.map((category) {
              final isSelected = _selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? CColors.primaryColor
                            : (isDark ? CColors.darkContainer : CColors.light),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ProductCategories.icons[category]!,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? Colors.grey.shade400
                                      : Colors.black),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _updateProduct(BuildContext context, Product product) async {
    final bool isDark = THelperFunctions.isDarkMode(context);
    final newExpiryDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newExpiryDate != null) {
      final additionalQuantity = await showDialog<int>(
        context: context,
        builder: (context) {
          final quantityController = TextEditingController();
          return AlertDialog(
            title: const Text('Cantidad Adicional'),
            content: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: isDark ? Colors.white : CColors.primaryColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text);
                  Navigator.pop(context, quantity);
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: isDark ? Colors.white : CColors.primaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (additionalQuantity != null && additionalQuantity > 0) {
        try {
          await _inventoryService.addQuantityAndExpiry(
            productId: product.id,
            additionalQuantity: additionalQuantity,
            newExpiryDate: newExpiryDate,
          );
          setState(() {
            _productsFuture = _inventoryService.fetchProducts();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nueva entrada agregada con éxito')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar la entrada: $e')),
          );
        }
      }
    }
  }

  // Widget _buildProductCard(Product product) {
  //   return GestureDetector(
  //     onTap: () => _showProductDetails(context, product),
  //     child: Card(
  //       color: Colors.white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       elevation: 5,
  //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Row(
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(8),
  //                     child:
  //                         _isValidNetworkUrl(product.photoUrl)
  //                             ? Image.network(
  //                               product.photoUrl!,
  //                               width: 80,
  //                               height: 80,
  //                               fit: BoxFit.cover,
  //                               errorBuilder: (context, error, stackTrace) {
  //                                 return const Icon(
  //                                   LucideIcons.image,
  //                                   size: 80,
  //                                   color: Colors.grey,
  //                                 );
  //                               },
  //                             )
  //                             : const Icon(Icons.fastfood, size: 80),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           product.name,
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           'Categoría: ${product.category}',
  //                           style: const TextStyle(color: Colors.grey),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Row(
  //                           children: [
  //                             const Icon(
  //                               LucideIcons.checkCircle,
  //                               color: Colors.green,
  //                               size: 12,
  //                             ),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               'Disponible',
  //                               style: const TextStyle(color: Colors.green),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               'Expira: ${product.expiryDate.toLocal()}'.split(
  //                                 ' ',
  //                               )[0],
  //                               style: const TextStyle(color: Colors.red),
  //                             ),
  //                             Text(
  //                               'Cantidad: ${product.quantity}',
  //                               style: const TextStyle(color: Colors.black),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 backgroundColor: CColors.primaryButton,
  //                 foregroundColor: CColors.secondaryButton,
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 12,
  //                   horizontal: 24,
  //                 ),
  //               ),
  //               onPressed: () => _updateProduct(context, product),
  //               child: const Text('Agregar Cantidad/Fecha'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProductCard(Product product, int index) {
    final isExpanded = _expandedIndexes.contains(index);
    final bool isDark = THelperFunctions.isDarkMode(context);

    return Card(
      color: isDark ? CColors.darkContainer : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Hero(
                  tag: 'product-photo-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        _isValidNetworkUrl(product.photoUrl)
                            ? Image.network(
                              product.photoUrl!,
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  LucideIcons.image,
                                  size: 80,
                                  color: Colors.grey,
                                );
                              },
                            )
                            : const Icon(Icons.fastfood, size: 80),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                ),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'expand-btn-${product.id}',
                  backgroundColor:
                      isDark ? CColors.resaltar : CColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedIndexes.remove(index);
                      } else {
                        _expandedIndexes.add(index);
                      }
                    });
                  },
                  child: Icon(
                    isExpanded ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 190 : 0,
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${product.quantity}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Último ingresado',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat.yMMMMd().format(product.entryDate)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Primero a expirar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat.yMMMMd().format(product.expiryDate)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a Expirar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${product.quantity}'),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                isDark
                                    ? CColors.resaltar
                                    : CColors.primaryButton,
                            foregroundColor: CColors.secondaryButton,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () => _updateProduct(context, product),
                          child: const Text('Agregar Cantidad/Fecha'),
                        ),

                        TextButton(
                          onPressed:
                              () => _showProductDetails(context, product),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                isDark
                                    ? CColors.resaltar
                                    : CColors.primaryButton,
                            foregroundColor: CColors.secondaryButton,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Ver más'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsWidget(product: product),
    );
  }
}
