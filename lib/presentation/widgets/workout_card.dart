import 'package:flutter/material.dart';
import 'package:myapp/domain/models/workout_models.dart';

/// Reusable workout card for displaying workout/content items
class WorkoutCard extends StatelessWidget {
  final WorkoutItem workout;
  final VoidCallback? onTap;
  final double width;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
    this.width = 240,
  });

  Color get _difficultyColor {
    switch (workout.difficulty.toUpperCase()) {
      case 'BEGINNER':
        return const Color(0xFF4CAF50);
      case 'INTERMEDIATE':
        return const Color(0xFFFF9800);
      case 'ADVANCED':
        return const Color(0xFFFF5722);
      default:
        return const Color(0xFF00ACC1);
    }
  }

  Color get _difficultyBgColor {
    switch (workout.difficulty.toUpperCase()) {
      case 'BEGINNER':
        return const Color(0xFFE8F5E9);
      case 'INTERMEDIATE':
        return const Color(0xFFFFF3E0);
      case 'ADVANCED':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFE0F7FA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay
            Stack(
              children: [
                // Main image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    width: width,
                    color: const Color(0xFFE0E0E0),
                    child: Image.network(
                      workout.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE0E0E0),
                          child: const Center(
                            child: Icon(
                              Icons.fitness_center_rounded,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Difficulty badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _difficultyBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      workout.difficulty.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _difficultyColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Play button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D95F),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D95F).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              workout.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Duration and instructor
            Text(
              '${workout.duration} • ${workout.instructor}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
