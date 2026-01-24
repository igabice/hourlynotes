import 'package:flutter/material.dart';

import '../note.dart';

/// Model for an activity entry
class ActivityEntry {
  final Note note;
  final String id;
  final String category;
  final String categoryColor;
  final String time;
  final String duration;
  final String description;
  final String? imageUrl;
  final IconData icon;
  final DateTime dateTime;

  ActivityEntry({
    required this.note,
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.time,
    required this.duration,
    required this.description,
    this.imageUrl,
    required this.icon,
    required this.dateTime,
  });
}

/// Enum for view modes
enum ViewMode { list, calendar }

/// Enum for filter options
enum FilterOption { day, week, month, projects }
