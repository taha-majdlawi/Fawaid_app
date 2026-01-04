import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fwaid_app/services/notes_manager.dart';
import 'package:fwaid_app/utiles/fwaid_helpers.dart';

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await NotesManager.loadNote(widget.id);
    _noteController.text = note ?? '';
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = generateSummary(widget.text);
    final category = autoCategory(widget.text);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontFamily: 'Amiri')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: widget.onFavoriteToggle,
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 🟢 التصنيف
                  Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(
                        category,
                        style: const TextStyle(fontFamily: 'Amiri'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 📖 النص
                  Text(
                    widget.text,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: widget.fontSize,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🧠 الخلاصة
                  const Text(
                    "خلاصة الفائدة",
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      summary,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: 'Amiri'),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 📝 الملاحظات
                  const Text(
                    "ملاحظتي على الفائدة",
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: "اكتب تأملك أو الفائدة التي فهمتها...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      NotesManager.saveNote(widget.id, value);
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نسخ النص')),
          );
        },
        icon: const Icon(Icons.copy),
        label: const Text("نسخ", style: TextStyle(fontFamily: 'Amiri')),
      ),
    );
  }
}
