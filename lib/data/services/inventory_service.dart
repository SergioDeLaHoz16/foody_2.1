// lib/features/inventory/services/inventory_service.dart
import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/inventory/models/models.dart';

class InventoryService {
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    try {
      final collection = MongoDBHelper.db.collection('products');
      await collection.update(
        {'_id': productId},
        {
          '\$set': {'quantity': newQuantity},
        },
      );
      print('Cantidad de producto actualizada en MongoDB');
    } catch (e) {
      print('Error al actualizar la cantidad del producto: $e');
      rethrow;
    }
  }
}
