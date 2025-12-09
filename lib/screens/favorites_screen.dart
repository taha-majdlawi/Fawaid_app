import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/services/favorites_manager.dart';
import 'package:fwaid_app/widgets/fwaid_tile_widget.dart';

class FavoritesScreen extends StatefulWidget {
  final double fontSize;
  final List<String> favoriteIds;

  const FavoritesScreen({
    Key? key,
    required this.fontSize,
    required this.favoriteIds,
  }) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}
class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favoriteIds);
  }

  void _removeFromFavorites(String id) async {
    setState(() {
      _favorites.remove(id);
    });
    await FavoritesManager.saveFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteItems =
        fwaidData.where((item) => _favorites.contains(item.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("المفضلة")),
      body: favoriteItems.isEmpty
          ? const Center(child: Text("لا توجد عناصر مفضلة"))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (_, index) {
                final dua = favoriteItems[index];
                return FwaidTile(
                  dua: dua,
                  fontSize: widget.fontSize,
                  isFavorite: true,
                  onFavoriteToggle: () => _removeFromFavorites(dua.id),
                  onTap: () {},
                );
              },
            ),
    );
  }
}

