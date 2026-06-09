import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Alarm {
  final String id;
  final String label;
  final int hour;
  final int minute;
  final bool isEnabled;

  Alarm({
    required this.id,
    required this.label,
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  String get time {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String formattedTime(BuildContext context) {
    return TimeOfDay(hour: hour, minute: minute).format(context);
  }

  Alarm copyWith({
    String? id,
    String? label,
    int? hour,
    int? minute,
    bool? isEnabled,
  }) {
    return Alarm(
      id: id ?? this.id,
      label: label ?? this.label,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'time': time,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'label': label,
      'time': time,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
    };
  }

  factory Alarm.fromFirestore(String id, Map<String, dynamic> data) {
    final hour = (data['hour'] as num?)?.toInt();
    final minute = (data['minute'] as num?)?.toInt();

    if (hour != null && minute != null) {
      return Alarm(
        id: id,
        label: data['label'] as String? ?? 'Alarm',
        hour: hour,
        minute: minute,
        isEnabled: data['isEnabled'] as bool? ?? true,
      );
    }

    return Alarm.fromTimeString(
      id: id,
      label: data['label'] as String? ?? 'Alarm',
      time: data['time'] as String? ?? '12:00 AM',
      isEnabled: data['isEnabled'] as bool? ?? true,
    );
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] as String,
      label: json['label'] as String? ?? 'Alarm',
      hour: (json['hour'] as num?)?.toInt() ?? 0,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  factory Alarm.fromTimeString({
    required String id,
    required String label,
    required String time,
    bool isEnabled = true,
  }) {
    final parts = time.split(' ');
    final timeParts = parts.first.split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return Alarm(
      id: id,
      label: label,
      hour: hour,
      minute: minute,
      isEnabled: isEnabled,
    );
  }

  static void sortList(List<Alarm> alarms) {
    alarms.sort((a, b) {
      if (a.hour != b.hour) return a.hour.compareTo(b.hour);
      return a.minute.compareTo(b.minute);
    });
  }
}
