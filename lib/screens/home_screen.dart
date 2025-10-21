import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final query = ref.watch(queryProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    final filtered = notes.where((n) {
      final matchesQuery = query.isEmpty ||
          n.title.toLowerCase().contains(query.toLowerCase()) ||
          n.body.toLowerCase().contains(query.toLowerCase());
      final matchesTag = selectedTag == null || n.tags.contains(selectedTag);
      return matchesQuery && matchesTag;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final tags = {
      for (final n in notes) ...n.tags,
    }.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Notes."),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newNote = Note.newNote();
          await ref.read(notesProvider.notifier).add(newNote);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteEditorScreen(note: newNote)),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("New"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search notes...",
              ),
              onChanged: (v) => ref.read(queryProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text("All"),
                    selected: selectedTag == null,
                    onSelected: (_) => ref.read(selectedTagProvider.notifier).state = null,
                  ),
                  const SizedBox(width: 8),
                  ...tags.map((t) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t),
                          selected: selectedTag == t,
                          onSelected: (_) => ref.read(selectedTagProvider.notifier).state = t,
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final n = filtered[i];
                  return Dismissible(
                    key: Key(n.id),
                    onDismissed: (_) => ref.read(notesProvider.notifier).remove(n.id),
                    child: NoteCard(
                      note: n,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NoteEditorScreen(note: n)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
