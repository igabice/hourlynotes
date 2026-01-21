import 'package:flutter/material.dart';

/// Reusable info chip widget for duration, location, etc.
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = const Color(0xFF00838F),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
