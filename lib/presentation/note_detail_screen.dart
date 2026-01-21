import 'package:flutter/material.dart';
import 'package:hourlynotes/domain/models/activity_models.dart';
import 'package:hourlynotes/presentation/widgets/tag_badge.dart';
import 'package:hourlynotes/presentation/widgets/info_chip.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatelessWidget {
  final ActivityEntry activity;

  const NoteDetailScreen({super.key, required this.activity});

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

  String _getTimeRange() {
    // Parse the time from activity.time (e.g., "09:00 AM")
    final startTime = activity.time;

    // Calculate end time based on duration
    // For now, just use a placeholder - in real app, this would be calculated
    final durationMatch = RegExp(
      r'(\d+)\s*(h|m|min)',
    ).allMatches(activity.duration);
    int totalMinutes = 0;

    for (var match in durationMatch) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!;

      if (unit == 'h') {
        totalMinutes += value * 60;
      } else {
        totalMinutes += value;
      }
    }

    // For display purposes, create an end time
    // In a real app, you'd properly parse and calculate this
    return '$startTime - ${_addMinutesToTime(startTime, totalMinutes)}';
  }

  String _addMinutesToTime(String timeStr, int minutes) {
    // Simple time addition for display
    // Parse time format like "09:00 AM"
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      final hourStr = parts[0];
      final minuteParts = parts[1].split(' ');
      final minute = int.tryParse(minuteParts[0]) ?? 0;
      final period = minuteParts.length > 1 ? minuteParts[1] : 'AM';
      int hour = int.tryParse(hourStr) ?? 9;

      final newMinutes = minute + minutes;
      final newHour = hour + (newMinutes ~/ 60);
      final finalMinutes = newMinutes % 60;

      return '${newHour % 12 == 0 ? 12 : newHour % 12}:${finalMinutes.toString().padLeft(2, '0')} $period';
    }

    return '10:00 AM'; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time range
                    _buildTimeRange(),
                    const SizedBox(height: 20),

                    // Tags
                    _buildTags(),
                    const SizedBox(height: 16),

                    // Created date
                    _buildCreatedDate(),
                    const SizedBox(height: 24),

                    // Main content card
                    _buildContentCard(),
                    const SizedBox(height: 20),

                    // Edit button
                    _buildEditButton(context),
                    const SizedBox(height: 12),

                    // Delete button
                    _buildDeleteButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          // Title
          const Text(
            'Note Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          // Edit button
          GestureDetector(
            onTap: () {
              // TODO: Navigate to edit mode
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00ACC1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRange() {
    return Text(
      _getTimeRange(),
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        height: 1.2,
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        TagBadge(
          label: activity.category,
          icon: Icons.work_outline_rounded,
          color: _categoryColor,
          backgroundColor: _categoryBgColor,
        ),
        const TagBadge(
          label: 'High Focus',
          icon: Icons.bolt_rounded,
          color: Color(0xFFFF6B6B),
          backgroundColor: Color(0xFFFFE8E8),
        ),
      ],
    );
  }

  Widget _buildCreatedDate() {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeAgo = _getTimeAgo(activity.dateTime);

    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 16,
          color: Color(0xFF00ACC1),
        ),
        const SizedBox(width: 6),
        Text(
          'Created $timeAgo • ${dateFormat.format(activity.dateTime)}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF00ACC1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildContentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Image
          if (activity.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                activity.imageUrl!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: const Color(0xFFE0E0E0),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Project Strategy Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF00ACC1).withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Metadata
                Wrap(
                  spacing: 20,
                  runSpacing: 12,
                  children: [
                    InfoChip(
                      icon: Icons.access_time_rounded,
                      label: 'Duration: ${activity.duration}',
                    ),
                    const InfoChip(
                      icon: Icons.location_on_rounded,
                      label: 'Main Office',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to edit screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00838F),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Edit Entry',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          _showDeleteConfirmation(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF6B6B),
          side: const BorderSide(color: Color(0xFFFFE8E8), width: 2),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.delete_outline_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Delete Note',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
          'Are you sure you want to delete this note? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete note
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted successfully'),
                  backgroundColor: Color(0xFF00838F),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
