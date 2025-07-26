import 'package:flutter/material.dart';
import 'package:foody/features/favorites/services/favorite_service.dart';

class FavoriteController extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();
  Set<String> _favoriteRecipeIds = {};

  Set<String> get favoriteRecipeIds => _favoriteRecipeIds;

  Future<void> loadFavorites(String userEmail) async {
    final ids = await _service.getFavoriteRecipeIds(userEmail);
    _favoriteRecipeIds = ids.toSet();
    notifyListeners();
  }

  Future<void> toggleFavorite(String userEmail, String recipeId) async {
    if (_favoriteRecipeIds.contains(recipeId)) {
      await _service.removeFavorite(userEmail, recipeId);
      _favoriteRecipeIds.remove(recipeId);
    } else {
      await _service.addFavorite(userEmail, recipeId);
      _favoriteRecipeIds.add(recipeId);
    }
    notifyListeners();
  }

  bool isFavorite(String recipeId) => _favoriteRecipeIds.contains(recipeId);
}
