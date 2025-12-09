import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:fwaid_app/widgets/fwaid_tile_widget.dart';

class FavoritesScreen extends StatelessWidget {
  final double fontSize;
  final List<String> favoriteTitles;

  const FavoritesScreen({
    Key? key,
    required this.fontSize,
    required this.favoriteTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteItems = fwaidData.where((item) => favoriteTitles.contains(item.name)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text("لا توجد عناصر مفضلة"))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final dua = favoriteItems[index];
                return FwaidTile(
                  dua: dua,
                  fontSize: fontSize,
                  isFavorite: true,
                  onFavoriteToggle: () {},
                  onTap: () {},
                );
              },
            ),
    );
  }
}
