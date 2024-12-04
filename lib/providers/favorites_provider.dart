import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';

class FavoritesProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  List<FoodItem> _favoriteFoods = [];

  FavoritesProvider(this._prefs) {
    _loadFavorites();
  }

  List<FoodItem> get favorites => _favoriteFoods;

  void _loadFavorites() {
    List<String>? favoritesJson = _prefs.getStringList('favorites');
    if (favoritesJson != null) {
      _favoriteFoods = favoritesJson
          .map((jsonString) => FoodItem.fromJson(json.decode(jsonString)))
          .toList();
      notifyListeners();
    }
  }

  void toggleFavorite(FoodItem foodItem) {
    final index = _favoriteFoods.indexWhere((f) => f.foodName == foodItem.foodName);
    
    if (index != -1) {
      // Remove from favorites
      _favoriteFoods.removeAt(index);
    } else {
      // Add to favorites
      _favoriteFoods.add(foodItem);
    }

    // Save to SharedPreferences
    _saveFavorites();
    notifyListeners();
  }

  void _saveFavorites() {
    List<String> favoritesJson = _favoriteFoods
        .map((foodItem) => json.encode(foodItem.toJson()))
        .toList();
    _prefs.setStringList('favorites', favoritesJson);
  }

  bool isFavorite(FoodItem foodItem) {
    return _favoriteFoods.any((f) => f.foodName == foodItem.foodName);
  }
}