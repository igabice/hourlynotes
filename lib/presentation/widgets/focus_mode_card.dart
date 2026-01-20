import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/presentation/settings_provider.dart';

class FocusModeCard extends StatelessWidget {
  const FocusModeCard({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FOCUS MODE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Permanent Snooze Lock', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                'Requires a typed note explaining why you are skipping a tracking hour. No exceptions',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Switch(
                value: settingsProvider.permanentSnoozeLock,
                onChanged: (value) => settingsProvider.setPermanentSnoozeLock(value),
                activeColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
