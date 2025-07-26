import 'package:flutter/material.dart';
import 'package:foody/features/auth/models/models.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/data/services/auth_service.dart';

class DataProvider with ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();

  List<dynamic> _recipes = [];
  List<dynamic> _products = [];
  List<UserModel> _users = [];
  int _totalRecipes = 0;
  int _criticalCount = 0;
  int _mediumCount = 0;

  UserModel? _currentUser;

  List<dynamic> get recipes => _recipes;
  List<dynamic> get products => _products;
  List<UserModel> get users => _users;
  int get totalRecipes => _totalRecipes;
  int get criticalCount => _criticalCount;
  int get mediumCount => _mediumCount;
  UserModel? get currentUser => _currentUser;

  // Devuelve solo las recetas creadas por el usuario autenticado
  List<dynamic> get myRecipes =>
      _currentUser == null
          ? []
          : _recipes.where((r) => r.createdBy == _currentUser!.correo).toList();

  // Devuelve solo los productos creados por el usuario autenticado
  List<dynamic> get myProducts =>
      _currentUser == null
          ? []
          : _products
              .where((p) => p.createdBy == _currentUser!.correo)
              .toList();

  Future<void> loadRecipes() async {
    _recipes = await _recipeService.fetchRecipes();
    _totalRecipes = _recipes.length;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _products = await _inventoryService.fetchProducts();
    final now = DateTime.now();
    _criticalCount =
        _products.where((product) {
          final daysToExpire = product.expiryDate.difference(now).inDays;
          return daysToExpire >= 0 && daysToExpire <= 5;
        }).length;

    _mediumCount =
        _products.where((product) {
          final daysToExpire = product.expiryDate.difference(now).inDays;
          return daysToExpire >= 6 && daysToExpire <= 10;
        }).length;

    notifyListeners();
  }

  Future<void> loadUsers() async {
    try {
      final usersData = await _authService.fetchAllUsers();
      _users = usersData.map((data) => UserModel.fromJson(data)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> addOrUpdateRecipe(dynamic newRecipe) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == newRecipe.id);
    if (index != -1) {
      _recipes[index] = newRecipe;
    } else {
      _recipes.add(newRecipe);
    }
    notifyListeners();
  }

  Future<void> addOrUpdateProduct(dynamic newProduct) async {
    final index = _products.indexWhere(
      (product) => product.id == newProduct.id,
    );
    if (index != -1) {
      _products[index] = newProduct;
    } else {
      _products.add(newProduct);
    }
    notifyListeners();
  }
}
