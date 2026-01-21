/*
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hourlynotes/domain/note.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [NoteSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveNote(Note note) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.notes.putSync(note));
  }

  Stream<List<Note>> listenToNotes() async* {
    final isar = await db;
    yield* isar.notes.where().watch(fireImmediately: true);
  }

  Future<void> deleteNote(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }
}
*/
