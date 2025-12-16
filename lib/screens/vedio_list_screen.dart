import 'package:flutter/material.dart';
import 'package:fwaid_app/data/fwaid_data.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ لا يمكن فتح الرابط')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ حدث خطأ أثناء فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'قائمة فيديوهات كتاب الفوائد',
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: playlistVideos.length,
        itemBuilder: (context, index) {
          final video = playlistVideos[index];
          return Card(
            color: theme.cardColor,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              title: Text(
                "${video['id']}. ${video['title']}",
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.play_arrow, color: theme.colorScheme.primary),
              onTap: () => _launchURL(context, video['url']!),
            ),
          );
        },
      ),
    );
  }
}
