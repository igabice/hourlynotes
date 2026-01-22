import 'package:flutter/material.dart';
import 'package:hourlynotes/domain/models/activity_models.dart';
import 'package:hourlynotes/presentation/note_detail_screen.dart';

/// Activity card widget for displaying activity entries
class ActivityCard extends StatelessWidget {
  final ActivityEntry activity;

  const ActivityCard({super.key, required this.activity});

  Color get _categoryColor {
    switch (activity.categoryColor) {
      case 'teal':
        return const Color(0xFF00838F);
      case 'pink':
        return const Color(0xFFFF6B9D);
      case 'cyan':
        return const Color(0xFF00ACC1);
      default:
        return const Color(0xFF00838F);
    }
  }

  Color get _categoryBgColor {
    switch (activity.categoryColor) {
      case 'teal':
        return const Color(0xFFE0F2F1);
      case 'pink':
        return const Color(0xFFFFE4EC);
      case 'cyan':
        return const Color(0xFFE0F7FA);
      default:
        return const Color(0xFFE0F2F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _categoryColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(width: 2, height: 100, color: const Color(0xFFE0E0E0)),
            ],
          ),
          const SizedBox(width: 16),
          // Card content
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(activity: activity),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                activity.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _categoryColor,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                activity.duration,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(
                                    0xFF00ACC1,
                                  ).withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Category icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _categoryBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            activity.icon,
                            color: _categoryColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Time
                    Text(
                      activity.time,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      activity.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF00ACC1).withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                    // Image attachment (if any)
                    // if (activity.imageUrl != null) ...[
                    //   const SizedBox(height: 16),
                    //   ClipRRect(
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Image.network(
                    //       activity.imageUrl!,
                    //       width: double.infinity,
                    //       height: 120,
                    //       fit: BoxFit.cover,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Container(
                    //           height: 120,
                    //           decoration: BoxDecoration(
                    //             color: const Color(0xFFE0E0E0),
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //           child: const Center(
                    //             child: Icon(
                    //               Icons.image_outlined,
                    //               size: 40,
                    //               color: Colors.grey,
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ],

                    if (activity.imageUrl != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: activity.imageUrl!.startsWith('http')
                            ? Image.network(
                                activity.imageUrl!,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imagePlaceholder();
                                },
                              )
                            : Image.file(
                                File(activity.imageUrl!),
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imagePlaceholder();
                                },
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
  return Container(
    height: 120,
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Center(
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: Colors.grey,
      ),
    ),
  );
}
}
