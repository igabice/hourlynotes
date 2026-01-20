import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _hourlyReminders = true;
  bool _weekendTracking = false;
  bool _permanentSnoozeLock = false;

  bool get hourlyReminders => _hourlyReminders;
  bool get weekendTracking => _weekendTracking;
  bool get permanentSnoozeLock => _permanentSnoozeLock;

  void setHourlyReminders(bool value) {
    _hourlyReminders = value;
    notifyListeners();
  }

  void setWeekendTracking(bool value) {
    _weekendTracking = value;
    notifyListeners();
  }

  void setPermanentSnoozeLock(bool value) {
    _permanentSnoozeLock = value;
    notifyListeners();
  }
}
