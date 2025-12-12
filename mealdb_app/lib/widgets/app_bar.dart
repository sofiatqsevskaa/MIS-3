import 'package:flutter/material.dart';
import '../view/favorites_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
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
  );
}
