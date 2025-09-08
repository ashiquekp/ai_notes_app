import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class StorageService {
  static const _fileName = 'notes.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Note>> loadNotes() async {
    try {
      final f = await _file();
      if (!await f.exists()) {
        await f.writeAsString(jsonEncode([]));
        return [];
      }
      final content = await f.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    final f = await _file();
    final encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    await f.writeAsString(encoded);
  }
}
