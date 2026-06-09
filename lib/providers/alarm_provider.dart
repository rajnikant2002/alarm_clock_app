import 'package:flutter/material.dart';
import '../models/alarm.dart';

class AlarmProvider extends ChangeNotifier {
  final List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    notifyListeners();
  }

  void toggleAlarm(int index, bool value) {
    _alarms[index].isEnabled = value;
    notifyListeners();
  }

  void deleteAlarm(int index) {
    _alarms.removeAt(index);
    notifyListeners();
  }
}