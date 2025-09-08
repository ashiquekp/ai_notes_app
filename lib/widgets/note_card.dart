import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  const NoteCard({super.key, required this.note, required this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title.isEmpty ? "Untitled" : note.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                note.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Wrap(
                spacing: 6,
                runSpacing: -8,
                children: note.tags.map((t) => Chip(label: Text(t))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
