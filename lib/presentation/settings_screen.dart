import 'package:flutter/material.dart';
import 'package:myapp/presentation/widgets/focus_mode_card.dart';
import 'package:myapp/presentation/widgets/notification_card.dart';
import 'package:myapp/presentation/widgets/schedule_card.dart';
import 'package:myapp/presentation/widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Tracking Preferences',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SectionHeader(title: 'DAILY SCHEDULE'),
            ScheduleCard(),
            SectionHeader(title: 'NOTIFICATIONS'),
            NotificationCard(),
            SizedBox(height: 16.0),
            FocusModeCard(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text('Save & Apply', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
