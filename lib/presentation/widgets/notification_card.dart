import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hourlynotes/presentation/settings_provider.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNotificationItem(
              context,
              icon: Icons.notifications,
              title: 'Hourly Reminders',
              subtitle: 'Ping every hour to log activity',
              value: settingsProvider.hourlyReminders,
              onChanged: (value) => settingsProvider.setHourlyReminders(value),
            ),
            const Divider(),
            _buildNotificationItem(
              context,
              icon: Icons.calendar_today,
              title: 'Weekend Tracking',
              subtitle: 'Keep the momentum on Sat & Sun',
              value: settingsProvider.weekendTracking,
              onChanged: (value) => settingsProvider.setWeekendTracking(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE0F2F1),
        child: Icon(icon, color: Colors.teal),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.teal,
      ),
    );
  }
}
