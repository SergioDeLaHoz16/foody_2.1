import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/favorites/models/favorite.dart';
import 'package:uuid/uuid.dart';

class FavoriteService {
  final _collection = MongoDBHelper.db.collection('favorites');

  Future<void> addFavorite(String userEmail, String recipeId) async {
    final id = const Uuid().v4();
    final favorite = Favorite(
      id: id,
      userEmail: userEmail,
      recipeId: recipeId,
      createdAt: DateTime.now(),
    );
    await _collection.insert(favorite.toMap());
  }

  Future<void> removeFavorite(String userEmail, String recipeId) async {
    await _collection.remove({'userEmail': userEmail, 'recipeId': recipeId});
  }

  Future<bool> isFavorite(String userEmail, String recipeId) async {
    final fav = await _collection.findOne({
      'userEmail': userEmail,
      'recipeId': recipeId,
    });
    return fav != null;
  }

  Future<List<String>> getFavoriteRecipeIds(String userEmail) async {
    final favorites = await _collection.find({'userEmail': userEmail}).toList();
    return favorites.map((f) => f['recipeId'] as String).toList();
  }

  Future<int> getFavoritesCount(String recipeId) async {
    final favorites = await _collection.find({'recipeId': recipeId}).toList();
    return favorites.length;
  }
}
