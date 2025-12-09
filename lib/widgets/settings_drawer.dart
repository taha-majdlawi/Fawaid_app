import 'package:flutter/material.dart';
import 'package:fwaid_app/screens/favorites_screen.dart';

class SettingsDrawer extends StatelessWidget {
  final double fontSize;
  final bool isDarkMode;
  final List<String> favorites;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onContactDeveloper;

  const SettingsDrawer({
    super.key,
    required this.fontSize,
    required this.isDarkMode,
    required this.favorites,
    required this.onFontSizeChanged,
    required this.onThemeChanged,
    required this.onContactDeveloper,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 132, 218, 209)),
            child: Text('الإعدادات',
              style: TextStyle(fontSize: 24, fontFamily: 'Amiri'),
            ),
          ),

          ListTile(
            title: const Text('المفضلة', style: TextStyle(fontFamily: 'Amiri')),
            trailing: const Icon(Icons.favorite),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(
                    fontSize: fontSize,
                    favoriteIds: favorites,
                  ),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            title: const Text('حجم الخط', style: TextStyle(fontFamily: 'Amiri')),
            subtitle: Slider(
              value: fontSize,
              min: 12,
              max: 30,
              divisions: 6,
              label: "${fontSize.round()}",
              onChanged: onFontSizeChanged,
            ),
          ),

          SwitchListTile(
            title: const Text("الوضع الليلي", style: TextStyle(fontFamily: 'Amiri')),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),

          const Divider(),

          ListTile(
            title: const Text('تواصل مع المطور', style: TextStyle(fontFamily: 'Amiri')),
            trailing: const Icon(Icons.chat),
            onTap: onContactDeveloper,
          ),
        ],
      ),
    );
  }
}
