import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

class InventoryService {
  Future<void> saveProduct(Product product) async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      await collection.insert(product.toMap());
      print('Product saved to MongoDB');
    } catch (e) {
      print('Error saving product: $e');
      rethrow;
    }
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      final products = await collection.find().toList();
      return products.map((data) => Product.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      await collection.update({'_id': id}, {'\$set': updatedData});
      print('Product updated in MongoDB');
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      await collection.remove({'_id': id});
      print('Product deleted from MongoDB');
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  Future<void> duplicateProductWithChanges({
    required Product originalProduct,
    required DateTime newExpiryDate,
    required int newQuantity,
  }) async {
    try {
      final newProduct = Product(
        id: const Uuid().v4(),
        name: originalProduct.name,
        category: originalProduct.category,
        entryDate: DateTime.now(),
        expiryDate: newExpiryDate,
        grams: originalProduct.grams,
        quantity: newQuantity,
        photoUrl: originalProduct.photoUrl,
        notes: originalProduct.notes,
        entradas: originalProduct.entradas ?? [],
        createdBy: originalProduct.createdBy,
      );
      await saveProduct(newProduct);
      print('Duplicated product saved to MongoDB');
    } catch (e) {
      print('Error duplicating product: $e');
      rethrow;
    }
  }

  Future<void> addQuantityAndExpiry({
    required String productId,
    required int additionalQuantity,
    required DateTime newExpiryDate,
  }) async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      final product = await collection.findOne({'_id': productId});

      if (product != null) {
        // Asegurarse de que los datos sean del tipo esperado
        final currentQuantity = product['quantity'] as int? ?? 0;
        final currentExpiryDate =
            product['expiryDate'] != null
                ? DateTime.parse(product['expiryDate'] as String)
                : DateTime.now();

        // Add a new entry to the "entradas" array
        final newEntry = {
          'entryDate': DateTime.now().toIso8601String(),
          'expiryDate': newExpiryDate.toIso8601String(),
          'grams': null,
          'quantity': additionalQuantity,
        };

        // Update the main fields of the product
        final updatedQuantity = currentQuantity + additionalQuantity;
        final updatedExpiryDate =
            newExpiryDate.isAfter(currentExpiryDate)
                ? newExpiryDate.toIso8601String()
                : currentExpiryDate.toIso8601String();

        await collection.updateOne(
          where.eq('_id', productId),
          modify
              .push('entradas', newEntry)
              .set('quantity', updatedQuantity)
              .set('expiryDate', updatedExpiryDate),
        );

        print('Product updated with new entry');
      } else {
        print('Product not found');
      }
    } catch (e) {
      print('Error adding new entry to product: $e');
      rethrow;
    }
  }

  Future<void> registerUsedProduct({
    required String productId,
    required String productName,
    required int usedQuantity,
    required String recipeId,
    required String recipeName,
    required String usedBy,
    DateTime? usedDate,
  }) async {
    try {
      final usedCollection = MongoDBHelper.db.collection('used_products');
      await usedCollection.insert({
        'productId': productId,
        'productName': productName,
        'usedQuantity': usedQuantity,
        'recipeId': recipeId,
        'recipeName': recipeName,
        'usedBy': usedBy,
        'usedDate': (usedDate ?? DateTime.now()).toIso8601String(),
      });
    } catch (e) {
      print('Error al registrar producto usado: $e');
      rethrow;
    }
  }
}
