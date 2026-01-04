import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fwaid_app/services/notes_manager.dart';

class FwaidDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String text;
  final double fontSize;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const FwaidDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.text,
    required this.fontSize,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<FwaidDetailScreen> createState() => _FwaidDetailScreenState();
}

class _FwaidDetailScreenState extends State<FwaidDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _isLoadingNote = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await NotesManager.loadNote(widget.id);
    setState(() {
      _noteController.text = note ?? '';
      _isLoadingNote = false;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontFamily: 'Amiri'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            tooltip:
                widget.isFavorite ? "إزالة من المفضلة" : "إضافة إلى المفضلة",
            onPressed: widget.onFavoriteToggle,
          ),
        ],
      ),

      body: _isLoadingNote
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 📖 نص الفائدة
                  Text(
                    widget.text,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontFamily: 'Amiri',
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 📝 عنوان الملاحظات
                  const Text(
                    "ملاحظتي على هذه الفائدة",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 📝 حقل الملاحظات
                  TextField(
                    controller: _noteController,
                    textDirection: TextDirection.rtl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "اكتب تأملك أو فهمك أو فائدة مستنبطة...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      NotesManager.saveNote(widget.id, value);
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

      // 📋 زر النسخ
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.text));
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
        icon: const Icon(Icons.copy),
        label: const Text(
          "نسخ النص",
          style: TextStyle(fontFamily: 'Amiri'),
        ),
      ),
    );
  }
}
