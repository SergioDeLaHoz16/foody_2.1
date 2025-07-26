import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';

class ProductController {
  void initializeFormFields({
    required Product? existingProduct,
    required TextEditingController nameController,
    required TextEditingController gramsController,
    required TextEditingController quantityController,
    required TextEditingController notesController,
    required Function(String?) setSelectedCategory,
    required Function(String?) setPhotoPath,
  }) {
    if (existingProduct != null) {
      nameController.text = existingProduct.name;
      gramsController.text = existingProduct.grams?.toString() ?? '';
      quantityController.text = existingProduct.quantity.toString();
      notesController.text = existingProduct.notes ?? '';
      setSelectedCategory(existingProduct.category);
      setPhotoPath(existingProduct.photoUrl);
    }
  }
}
