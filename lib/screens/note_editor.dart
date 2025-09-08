import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../services/ai_service.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note note;
  const NoteEditorScreen({super.key, required this.note});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _title;
  late TextEditingController _body;
  late TextEditingController _tags;
  bool _loadingSummary = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note.title);
    _body = TextEditingController(text: widget.note.body);
    _tags = TextEditingController(text: widget.note.tags.join(", "));
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final tags = _tags.text
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final updated = widget.note.copyWith(
      title: _title.text,
      body: _body.text,
      tags: tags,
    );
    await ref.read(notesProvider.notifier).update(updated);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _summarize() async {
    setState(() => _loadingSummary = true);
    final summary = await AIService.summarize(_body.text);
    setState(() => _loadingSummary = false);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("AI Summary"),
        content: SingleChildScrollView(child: Text(summary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          TextButton(
            onPressed: () {
              _body.text = "${_body.text}---Summary:\n$summary";
              Navigator.pop(context);
            },
            child: const Text("Insert"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadingSummary ? null : _summarize,
        label: _loadingSummary ? const Text("Summarizing...") : const Text("AI Summarize"),
        icon: const Icon(Icons.auto_awesome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: "Title"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _body,
              decoration: const InputDecoration(labelText: "Body"),
              maxLines: 12,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(labelText: "Tags (comma separated)"),
            ),
          ],
        ),
      ),
    );
  }
}
