import 'package:hive/hive.dart';

part 'note.g.dart'; // Run `flutter pub run build_runner build`

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

  @HiveField(5) // next available
  DateTime lastModified;

  @HiveField(5) // next available
  String? category;

  Note({
    required this.id,
    required this.text,
    required this.timestamp,
    DateTime? lastModified,
    this.localImagePath,
    this.driveImageFileId,
    this.category,
  }) : lastModified = lastModified ?? timestamp;

  Note copyWith({
    int? id,
    String? text,
    DateTime? timestamp,
    DateTime? lastModified,
    String? localImagePath,
    String? driveImageFileId,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      lastModified: lastModified ?? this.lastModified,
      localImagePath: localImagePath ?? this.localImagePath,
      driveImageFileId: driveImageFileId ?? this.driveImageFileId,
      category: category ?? this.category,
    );
  }


  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'driveImageFileId': driveImageFileId,
        'lastModified': lastModified.toIso8601String(),
        'category': category,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      driveImageFileId: json['driveImageFileId'] as String?,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
    );
  }
}