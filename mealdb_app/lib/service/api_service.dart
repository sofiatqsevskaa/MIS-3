import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category.dart';
import '../model/meal_summary.dart';
import '../model/meal_details.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';
  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List list = data['categories'] ?? [];
      return list.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$base/filter.php?c=$category'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List list = data['meals'] ?? [];
      return list.map((e) => MealSummary.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$base/search.php?s=$query'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List? list = data['meals'];
      if (list == null) return [];
      return list.map((e) => MealSummary.fromJson(e)).toList();
    }
    return [];
  }

  Future<MealDetails?> lookupMeal(String id) async {
    final res = await http.get(Uri.parse('$base/lookup.php?i=$id'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List? list = data['meals'];
      if (list == null || list.isEmpty) return null;
      return MealDetails.fromJson(list.first);
    }
    return null;
  }

  Future<MealDetails?> randomMeal() async {
    final res = await http.get(Uri.parse('$base/random.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List? list = data['meals'];
      if (list == null || list.isEmpty) return null;
      return MealDetails.fromJson(list.first);
    }
    return null;
  }
}
