import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  final storage = ref.read(storageServiceProvider);
  return NotesNotifier(storage)..init();
});

final queryProvider = StateProvider<String>((_) => "");
final selectedTagProvider = StateProvider<String?>((_) => null);

class NotesNotifier extends StateNotifier<List<Note>> {
  final StorageService storage;
  NotesNotifier(this.storage) : super(const []);

  Future<void> init() async {
    state = await storage.loadNotes();
  }

  Future<void> add(Note n) async {
    state = [...state, n];
    await storage.saveNotes(state);
  }

  Future<void> update(Note updated) async {
    state = [
      for (final n in state) if (n.id == updated.id) updated else n,
    ];
    await storage.saveNotes(state);
  }

  Future<void> remove(String id) async {
    state = state.where((n) => n.id != id).toList();
    await storage.saveNotes(state);
  }
}
