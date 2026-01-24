import 'package:flutter/foundation.dart';

@immutable
class UserSettings {
  final bool? notificationsEnabled;
  final List<int>? daysOfWeek;
  final List<int>? hoursOfDay;
  final String? notificationSound;
  final bool? vibrationEnabled;
  final int? ledColor;
  final bool? isSnoozeEnabled;
  final int? snoozeIntervalMinutes;
  final int? maxSnoozeCount;
  final bool? snoozeAutoDismiss;
  final List<String>? customLabels;

  const UserSettings({
    this.notificationsEnabled,
    this.daysOfWeek,
    this.hoursOfDay,
    this.notificationSound,
    this.vibrationEnabled,
    this.ledColor,
    this.isSnoozeEnabled,
    this.snoozeIntervalMinutes,
    this.maxSnoozeCount,
    this.snoozeAutoDismiss,
    this.customLabels,
  });


  UserSettings copyWith({
    bool? notificationsEnabled,
    List<int>? daysOfWeek,
    List<int>? hoursOfDay,
    String? notificationSound,
    bool? vibrationEnabled,
    int? ledColor,
    bool? isSnoozeEnabled,
    int? snoozeIntervalMinutes,
    int? maxSnoozeCount,
    bool? snoozeAutoDismiss,
    List<String>? customLabels,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      hoursOfDay: hoursOfDay ?? this.hoursOfDay,
      notificationSound: notificationSound ?? this.notificationSound,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      ledColor: ledColor ?? this.ledColor,
      isSnoozeEnabled: isSnoozeEnabled ?? this.isSnoozeEnabled,
      snoozeIntervalMinutes:
          snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
      maxSnoozeCount: maxSnoozeCount ?? this.maxSnoozeCount,
      snoozeAutoDismiss: snoozeAutoDismiss ?? this.snoozeAutoDismiss,
      customLabels: customLabels ?? this.customLabels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'daysOfWeek': daysOfWeek,
      'hoursOfDay': hoursOfDay,
      'notificationSound': notificationSound,
      'vibrationEnabled': vibrationEnabled,
      'ledColor': ledColor,
      'isSnoozeEnabled': isSnoozeEnabled,
      'snoozeIntervalMinutes': snoozeIntervalMinutes,
      'maxSnoozeCount': maxSnoozeCount,
      'snoozeAutoDismiss': snoozeAutoDismiss,
      'customLabels': customLabels,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notificationsEnabled: json['notificationsEnabled'],
      daysOfWeek:
          json['daysOfWeek'] != null ? List<int>.from(json['daysOfWeek']) : null,
      hoursOfDay:
          json['hoursOfDay'] != null ? List<int>.from(json['hoursOfDay']) : null,
      notificationSound: json['notificationSound'],
      vibrationEnabled: json['vibrationEnabled'],
      ledColor: json['ledColor'],
      isSnoozeEnabled: json['isSnoozeEnabled'],
      snoozeIntervalMinutes: json['snoozeIntervalMinutes'],
      maxSnoozeCount: json['maxSnoozeCount'],
      snoozeAutoDismiss: json['snoozeAutoDismiss'],
      customLabels: json['customLabels'] != null
          ? List<String>.from(json['customLabels'])
          : null,
    );
  }
}