import 'package:flutter/material.dart';
import 'package:fwaid_app/screens/favorites_screen.dart';
import 'package:fwaid_app/screens/vedio_list_screen.dart';

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
      // زر الانتقال إلى شاشة المفضلة
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
          onFavoritesUpdated(); // استدعاء عند العودة
        },
      ),

      // ✅ زر الانتقال إلى شاشة الفيديوهات
      IconButton(
        icon: const Icon(Icons.video_library),
        tooltip: 'قائمة الفيديوهات',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  VideoListScreen(),
            ),
          );
        },
      ),

      // زر فتح القائمة الجانبية
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
