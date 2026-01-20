import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Text('START TIME', style: TextStyle(color: Colors.grey)),
                    Text('09:00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('—', style: TextStyle(fontSize: 32, color: Colors.grey)),
                Column(
                  children: const [
                    Text('END TIME', style: TextStyle(color: Colors.grey)),
                    Text('21:00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.av_timer),
              label: const Text('Adjust Schedule Window'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFE0F2F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
