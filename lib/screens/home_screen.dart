import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/screens/fwaid_detail_screen.dart';
import 'package:fwaid_app/services/favorites_manager.dart';
import 'package:fwaid_app/utiles/fwaid_helpers.dart';
import 'package:fwaid_app/widgets/home_app_bar.dart';
import 'package:fwaid_app/widgets/settings_drawer.dart';
import 'package:fwaid_app/widgets/fwaid_tile_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List filteredList = [];

  // مفاتيح SharedPreferences
  static const String _lastOpenedKey = 'last_opened_fwaid_id';
  static const String _showContinueKey = 'show_continue_reading';

  String? lastOpenedId;
  dynamic lastOpenedItem;
  bool showContinueReading = true;

  @override
  void initState() {
    super.initState();
    filteredList = List.from(fwaidData);
    loadFavorites();
    loadSettings();
  }

  Future<void> loadFavorites() async {
    favorites = await FavoritesManager.loadFavorites();
    if (mounted) setState(() {});
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    showContinueReading = prefs.getBool(_showContinueKey) ?? true;
    await loadLastOpened();
  }

  Future<void> loadLastOpened() async {
    final prefs = await SharedPreferences.getInstance();
    lastOpenedId = prefs.getString(_lastOpenedKey);

    if (lastOpenedId != null && showContinueReading) {
      try {
        lastOpenedItem =
            fwaidData.firstWhere((item) => item.id == lastOpenedId);
      } catch (_) {
        lastOpenedItem = null;
      }
    } else {
      lastOpenedItem = null;
    }

    if (mounted) setState(() {});
  }

  Future<void> saveLastOpened(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastOpenedKey, id);
  }

  void toggleFavorite(String id) {
    setState(() {
      favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    });
    FavoritesManager.saveFavorites(favorites);
  }

  void updateSearch(String value) {
    setState(() {
      filteredList = fwaidData.where((item) {
        return item.name.contains(value) || item.text.contains(value);
      }).toList();
    });
  }

  Future<void> openDetail(dynamic item) async {
    await saveLastOpened(item.id);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FwaidDetailScreen(
          id: item.id,
          title: item.name,
          text: item.text,
          fontSize: widget.fontSize,
          isFavorite: favorites.contains(item.id),
          onFavoriteToggle: () => toggleFavorite(item.id),
        ),
      ),
    );

    await loadFavorites();
    await loadLastOpened();
  }

  @override
  Widget build(BuildContext context) {
    final dailyFwaid = getDailyFwaid(fwaidData);

    final cardBg =
        widget.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    final cardBorder =
        widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final subtitleColor =
        widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      appBar: buildHomeAppBar(
        context: context,
        fontSize: widget.fontSize,
        favorites: favorites,
        onFavoritesUpdated: loadFavorites,
      ),

      endDrawer: SettingsDrawer(
        fontSize: widget.fontSize,
        isDarkMode: widget.isDarkMode,
        favorites: favorites,
        onFontSizeChanged: widget.onFontSizeChanged,
        onThemeChanged: widget.onThemeChanged,
        onContactDeveloper: _launchWhatsApp,
        showContinueReading: showContinueReading,
        onContinueReadingChanged: (value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_showContinueKey, value);

          setState(() {
            showContinueReading = value;
            if (!value) {
              lastOpenedItem = null;
            } else {
              loadLastOpened();
            }
          });
        },
      ),

      // ✅ هنا التعديل الأساسي (Slivers)
      body: CustomScrollView(
        slivers: [

          // 📖 متابعة القراءة
          if (showContinueReading && lastOpenedItem != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: InkWell(
                  onTap: () => openDetail(lastOpenedItem),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cardBg,
                      border: Border.all(color: cardBorder),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          color: Colors.teal.shade600,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "متابعة القراءة",
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: widget.fontSize - 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                lastOpenedItem.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: widget.fontSize - 3,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_left, color: subtitleColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 📅 فائدة اليوم
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Card(
                child: ListTile(
                  title: const Text(
                    'فائدة اليوم',
                    style: TextStyle(fontFamily: 'Amiri'),
                  ),
                  subtitle: Text(
                    dailyFwaid.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.today),
                  onTap: () => openDetail(dailyFwaid),
                ),
              ),
            ),
          ),

          // 🔍 البحث
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: "ابحث عن فائدة...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: updateSearch,
              ),
            ),
          ),

          // 📋 قائمة الفوائد
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dua = filteredList[index];
                return FwaidTile(
                  dua: dua,
                  fontSize: widget.fontSize,
                  isFavorite: favorites.contains(dua.id),
                  onFavoriteToggle: () => toggleFavorite(dua.id),
                  onTap: () => openDetail(dua),
                );
              },
              childCount: filteredList.length,
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
