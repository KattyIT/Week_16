import 'model/note.dart';
import 'objectbox.g.dart';

class NotesRepository {
  late final Store _store;
  late final Box<Note> _box;

  List<Note> get notes => _box.getAll();

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Note>();
  }

  Future addNote(Note note) async {
    await _box.putAsync(note);
  }
  Future deleteNote(Note note) async {
    _box.remove(note.id);
  }
  Future updateNote(Note note) async {
    _box.remove(note.id);
    _box.putAsync(note);
  }
}