import 'package:flutter/material.dart';
import 'package:fwaid_app/screens/favorites_screen.dart';

AppBar buildHomeAppBar({
  required BuildContext context,
  required double fontSize,
  required List<String> favorites,
  required VoidCallback onFavoritesUpdated,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: const Text(
      "فوائد ابن القيم",
      style: TextStyle(fontFamily: 'Amiri'),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.favorite_border),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FavoritesScreen(
                fontSize: fontSize,
                favoriteIds: favorites,
              ),
            ),
          );

          // ✅ رجع نادِ HomeScreen
          onFavoritesUpdated();
        },
      ),
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    ],
  );
}
