/// Model for workout/content item
class WorkoutItem {
  final String id;
  final String title;
  final String duration;
  final String instructor;
  final String imageUrl;
  final String difficulty; // BEGINNER, INTERMEDIATE, ADVANCED
  final String category;

  WorkoutItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.instructor,
    required this.imageUrl,
    required this.difficulty,
    required this.category,
  });
}
