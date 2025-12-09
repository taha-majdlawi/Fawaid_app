import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fwaid_app/modles/fwaid.dart';

class FwaidTile extends StatelessWidget {
  final Fwaid dua;
   final VoidCallback onTap;
   final VoidCallback onFavoriteToggle;
   final bool isFavorite;
  final double fontSize;

  const FwaidTile({
    Key? key,
    required this.dua,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //  onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textDirection: TextDirection.rtl,
                dua.name,
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              Text(
                dua.text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Amiri',
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      //           isFavorite ? Icons.favorite : Icons.favorite_border,
                      //          color: isFavorite
                      //              ? const Color.fromARGB(255, 55, 52, 52)
                      //              : Colors.teal,
                    ),
                    //  onPressed: onFavoriteToggle,
                    //   tooltip: isFavorite
                    //      ? 'إزالة من المفضلة'
                    //       : 'إضافة إلى المفضلة',
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.teal),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: dua.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تم نسخ الدعاء',
                            style: TextStyle(fontFamily: 'Amiri'),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'نسخ الدعاء',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
