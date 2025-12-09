import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/screens/favorites_screen.dart';
import 'package:fwaid_app/widgets/fwaid_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late SharedPreferences prefs;
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
      prefs.setStringList('favorites', favorites);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "فوائد ابن القيم",
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 218, 209),
              ),
              child: Text(
                'الإعدادات',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'المفضلة',
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              trailing: const Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoritesScreen(
                      fontSize: widget.fontSize,
                      favoriteTitles: favorites,
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              title: const Text(
                'حجم الخط',
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              subtitle: Slider(
                value: widget.fontSize,
                min: 12,
                max: 30,
                divisions: 6,
                label: "${widget.fontSize.round()}",
                onChanged: widget.onFontSizeChanged,
              ),
            ),
            SwitchListTile(
              title: const Text(
                "الوضع الليلي",
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              title: const Text(
                'تواصل مع المطور',
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              trailing: const Icon(Icons.chat),
              onTap: _launchWhatsApp,
            ),
          ],
        ),
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
            onTap: () {}, // لاحقًا يمكن فتح التفاصيل
          );
        },
      ),
    );
  }

  void _launchWhatsApp() async {
    final url = Uri.parse(
      "https://wa.me/972592345890?text=السلام عليكم، أريد التواصل مع مطور تطبيق فوائد ابن القيم",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'تعذر فتح WhatsApp';
    }
  }
}
