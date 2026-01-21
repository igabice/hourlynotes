import 'package:flutter/material.dart';

/// Date separator widget for timeline
class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        date.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF00ACC1).withOpacity(0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
