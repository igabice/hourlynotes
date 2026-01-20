/*
import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;
  late String text;
  late DateTime timestamp;
  String? imagePath;
}
*/

class Note {
  int id;
  String text;
  DateTime timestamp;
  String? imagePath;

  Note({required this.id, required this.text, required this.timestamp, this.imagePath});
}