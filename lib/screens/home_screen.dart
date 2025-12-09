import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/services/favorites_manager.dart';
import 'package:fwaid_app/widgets/home_app_bar.dart';
import 'package:fwaid_app/widgets/settings_drawer.dart';
import 'package:fwaid_app/widgets/fwaid_tile_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final double fontSize;
  final bool isDarkMode;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.fontSize,
    required this.isDarkMode,
    required this.onFontSizeChanged,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favorites = await FavoritesManager.loadFavorites();
    setState(() {});
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
    });
    FavoritesManager.saveFavorites(favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(
        context: context,
        fontSize: widget.fontSize,
        favorites: favorites,
      ),

      endDrawer: SettingsDrawer(
        fontSize: widget.fontSize,
        isDarkMode: widget.isDarkMode,
        favorites: favorites,
        onFontSizeChanged: widget.onFontSizeChanged,
        onThemeChanged: widget.onThemeChanged,
        onContactDeveloper: _launchWhatsApp,
      ),

      body: ListView.builder(
        itemCount: fwaidData.length,
        itemBuilder: (context, index) {
          final dua = fwaidData[index];
          return FwaidTile(
            dua: dua,
            fontSize: widget.fontSize,
            isFavorite: favorites.contains(dua.name),
            onFavoriteToggle: () => toggleFavorite(dua.name),
            onTap: () {},
          );
        },
      ),
    );
  }

  void _launchWhatsApp() async {
    final url = Uri.parse(
      "https://wa.me/972592345890?text=السلام عليكم، أريد التواصل مع مطور تطبيق فوائد ابن القيم",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
