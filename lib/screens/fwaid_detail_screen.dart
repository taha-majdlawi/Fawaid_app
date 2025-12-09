import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FwaidDetailScreen extends StatelessWidget {
  final String title;
  final String text;
  final double fontSize;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const FwaidDetailScreen({
    super.key,
    required this.title,
    required this.text,
    required this.fontSize,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Amiri')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: onFavoriteToggle,
            tooltip: isFavorite ? "إزالة من المفضلة" : "إضافة للمفضلة",
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Amiri',
              height: 1.6,
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم نسخ النص',
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              duration: Duration(seconds: 1),
            ),
          );
        },
        label: const Text("نسخ", style: TextStyle(fontFamily: 'Amiri')),
        icon: const Icon(Icons.copy),
      ),
    );
  }
}
