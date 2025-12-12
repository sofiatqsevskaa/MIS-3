import 'package:flutter/material.dart';
import '../model/meal_summary.dart';

class FavoritesService extends ChangeNotifier {
  final List<MealSummary> _favorites = [];
  List<MealSummary> get favorites => _favorites;

  void toggleFavorite(MealSummary meal) {
    final existing = _favorites.indexWhere((m) => m.id == meal.id);
    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((m) => m.id == id);
  }
}
