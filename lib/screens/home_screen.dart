import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/screens/fwaid_detail_screen.dart';
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
  String searchQuery = "";
  List filteredList = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    filteredList = fwaidData;
  }

  Future<void> loadFavorites() async {
    favorites = await FavoritesManager.loadFavorites();
    setState(() {});
  }

  void toggleFavorite(String id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
    FavoritesManager.saveFavorites(favorites);
  }

  void updateSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredList = fwaidData.where((item) {
        return item.name.contains(value) || item.text.contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(
        context: context,
        fontSize: widget.fontSize,
        favorites: favorites,
        onFavoritesUpdated: loadFavorites, // ✅ هنا الحل
      ),

      endDrawer: SettingsDrawer(
        fontSize: widget.fontSize,
        isDarkMode: widget.isDarkMode,
        favorites: favorites,
        onFontSizeChanged: widget.onFontSizeChanged,
        onThemeChanged: widget.onThemeChanged,
        onContactDeveloper: _launchWhatsApp,
      ),

      body: Column(
        children: [
          // 🔍 صندوق البحث
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: "ابحث عن فائدة...",
                hintTextDirection: TextDirection.rtl,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: updateSearch,
            ),
          ),

          // 📋 قائمة الأدعية (مفلترة حسب البحث)
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final dua = filteredList[index];
                return FwaidTile(
                  dua: dua,
                  fontSize: widget.fontSize,
                  isFavorite: favorites.contains(dua.id),
                  onFavoriteToggle: () => toggleFavorite(dua.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FwaidDetailScreen(
                          title: dua.name,
                          text: dua.text,
                          fontSize: widget.fontSize,
                          isFavorite: favorites.contains(dua.name),
                          onFavoriteToggle: () => toggleFavorite(dua.name),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
