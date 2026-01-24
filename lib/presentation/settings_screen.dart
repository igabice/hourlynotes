import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourlynotes/domain/controller/user_settings_controller.dart';
import 'package:hourlynotes/domain/models/user_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserSettingsController controller = Get.find<UserSettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Obx(() {
        final settings = controller.userSettings.value;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Tracking Preferences',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              _buildScheduleSection(settings, controller),
              _buildNotificationSection(settings, controller),
              _buildSnoozeSection(settings, controller),
              _buildCustomLabelsSection(settings, controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildScheduleSection(
      UserSettings settings, UserSettingsController controller) {
    List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('DAILY SCHEDULE'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Days of Week',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    final isSelected =
                        settings.daysOfWeek?.contains(index) ?? false;
                    return GestureDetector(
                      onTap: () {
                        List<int> updatedDays =
                            List.from(settings.daysOfWeek ?? []);
                        if (isSelected) {
                          updatedDays.remove(index);
                        } else {
                          updatedDays.add(index);
                        }
                        controller.updateUserSettings(
                            settings.copyWith(daysOfWeek: updatedDays));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            isSelected ? Colors.teal : Colors.grey.shade200,
                        child: Text(
                          days[index],
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text('Hours of Day',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                RangeSlider(
                  values: RangeValues(
                    (settings.hoursOfDay?.isNotEmpty == true
                            ? settings.hoursOfDay!.first
                            : 9)
                        .toDouble(),
                    (settings.hoursOfDay?.isNotEmpty == true
                            ? settings.hoursOfDay!.last
                            : 21)
                        .toDouble(),
                  ),
                  min: 0,
                  max: 23,
                  divisions: 23,
                  labels: RangeLabels(
                    '${settings.hoursOfDay?.isNotEmpty == true ? settings.hoursOfDay!.first : 9}:00',
                    '${settings.hoursOfDay?.isNotEmpty == true ? settings.hoursOfDay!.last : 21}:00',
                  ),
                  onChanged: (values) {
                    List<int> hours = [];
                    for (int i = values.start.toInt();
                        i <= values.end.toInt();
                        i++) {
                      hours.add(i);
                    }
                    controller
                        .updateUserSettings(settings.copyWith(hoursOfDay: hours));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(
      UserSettings settings, UserSettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('NOTIFICATIONS'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: settings.notificationsEnabled ?? false,
                onChanged: (value) {
                  controller.updateUserSettings(
                      settings.copyWith(notificationsEnabled: value));
                },
                activeColor: Colors.teal,
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Enable Vibration',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: settings.vibrationEnabled ?? false,
                onChanged: (value) {
                  controller.updateUserSettings(
                      settings.copyWith(vibrationEnabled: value));
                },
                activeColor: Colors.teal,
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Notification Sound',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: DropdownButton<String>(
                  value: settings.notificationSound ?? 'default',
                  items: ['default', 'sound1', 'sound2']
                      .map((sound) => DropdownMenuItem(
                            value: sound,
                            child: Text(sound),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.updateUserSettings(
                        settings.copyWith(notificationSound: value));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnoozeSection(
      UserSettings settings, UserSettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SNOOZE'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enable Snooze',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: settings.isSnoozeEnabled ?? false,
                onChanged: (value) {
                  controller.updateUserSettings(
                      settings.copyWith(isSnoozeEnabled: value));
                },
                activeColor: Colors.teal,
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Snooze Interval (minutes)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(
                    '${settings.snoozeIntervalMinutes ?? 5} min'),
              ),
              Slider(
                value: (settings.snoozeIntervalMinutes ?? 5).toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                label: '${settings.snoozeIntervalMinutes ?? 5}',
                onChanged: (value) {
                  controller.updateUserSettings(
                      settings.copyWith(snoozeIntervalMinutes: value.toInt()));
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Auto-dismiss Snooze',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: settings.snoozeAutoDismiss ?? false,
                onChanged: (value) {
                  controller.updateUserSettings(
                      settings.copyWith(snoozeAutoDismiss: value));
                },
                activeColor: Colors.teal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomLabelsSection(
      UserSettings settings, UserSettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CUSTOM LABELS'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...(settings.customLabels ?? []).map((label) => ListTile(
                      title: Text(label),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          List<String> updatedLabels =
                              List.from(settings.customLabels ?? []);
                          updatedLabels.remove(label);
                          controller.updateUserSettings(
                              settings.copyWith(customLabels: updatedLabels));
                        },
                      ),
                    )),
                ListTile(
                  title: TextField(
                    decoration:
                        const InputDecoration(hintText: 'Add a new label'),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        List<String> updatedLabels =
                            List.from(settings.customLabels ?? []);
                        updatedLabels.add(value);
                        controller.updateUserSettings(
                            settings.copyWith(customLabels: updatedLabels));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
