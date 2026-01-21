import 'package:hive/hive.dart';

// part 'note.g.dart'; // Run `flutter pub run build_runner build`

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String? localImagePath;

  @HiveField(4)
  String? driveImageFileId;

  Note({
    required this.id,
    required this.text,
    required this.timestamp,
    this.localImagePath,
    this.driveImageFileId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'driveImageFileId': driveImageFileId,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      driveImageFileId: json['driveImageFileId'] as String?,
    );
  }
}