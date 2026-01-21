class UserSettings {
  final int startHour; // e.g., 8 (8 AM)
  final int endHour;   // e.g., 22 (10 PM)
  final bool isNagEnabled; // If true, alarm repeats until note is entered
  final int snoozeIntervalMinutes; // Default to 5 or 10
  final List<String> customLabels; // User-defined labels like "Work", "Deep Work"
  final String themeMode; // "light", "dark", or "system"

  UserSettings({
    this.startHour = 9,
    this.endHour = 21,
    this.isNagEnabled = true,
    this.snoozeIntervalMinutes = 5,
    this.customLabels = const ["Work", "Health", "Leisure", "Chore"],
    this.themeMode = "system",
  });

  // To save to Google Drive as settings.json
  Map<String, dynamic> toJson() => {
        'startHour': startHour,
        'endHour': endHour,
        'isNagEnabled': isNagEnabled,
        'snoozeIntervalMinutes': snoozeIntervalMinutes,
        'customLabels': customLabels,
        'themeMode': themeMode,
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      startHour: json['startHour'] as int,
      endHour: json['endHour'] as int,
      isNagEnabled: json['isNagEnabled'] as bool,
      snoozeIntervalMinutes: json['snoozeIntervalMinutes'] as int,
      customLabels: (json['customLabels'] as List<dynamic>).cast<String>(),
      themeMode: json['themeMode'] as String,
    );
  }

  UserSettings copyWith({
    int? startHour,
    int? endHour,
    bool? isNagEnabled,
    int? snoozeIntervalMinutes,
    List<String>? customLabels,
    String? themeMode,
  }) {
    return UserSettings(
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      isNagEnabled: isNagEnabled ?? this.isNagEnabled,
      snoozeIntervalMinutes:
          snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
      customLabels: customLabels ?? this.customLabels,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
