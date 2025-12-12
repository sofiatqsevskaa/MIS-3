import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/meal_summary.dart';
import '../service/api_service.dart';
import '../service/favorites_service.dart';
import '../widgets/meal_card.dart';
import 'favorites_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({required this.category, Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService api = ApiService();
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() async {
    final m = await api.fetchMealsByCategory(widget.category);
    setState(() {
      meals = m;
      filtered = m;
      loading = false;
    });
  }

  void _onSearch(String q) {
    if (q.trim().isEmpty) {
      setState(() => filtered = meals);
      return;
    }
    setState(() {
      filtered = meals
          .where((meal) => meal.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search meals...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                if (!loading)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      '${filtered.length} ${filtered.length == 1 ? 'meal' : 'meals'} found',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No meals found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try a different search term',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => MealCard(
                            meal: filtered[i],
                            isFavorite: favoritesService.isFavorite(
                              filtered[i].id,
                            ),
                            onFavoriteToggle: (_) =>
                                favoritesService.toggleFavorite(filtered[i]),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
