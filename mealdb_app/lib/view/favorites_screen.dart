import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/favorites_service.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesService>().favorites;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          if (favs.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                '${favs.length} ${favs.length == 1 ? 'meal' : 'meals'} saved',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: favs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorite meals yet!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start adding meals to your favorites',
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
                    itemCount: favs.length,
                    itemBuilder: (context, index) {
                      final meal = favs[index];
                      return MealCard(
                        meal: meal,
                        isFavorite: true,
                        onFavoriteToggle: (_) {
                          context.read<FavoritesService>().toggleFavorite(meal);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
