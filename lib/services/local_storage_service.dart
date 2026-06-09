import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/alarm.dart';

class LocalStorageService {
  String _cacheKey(String uid) => 'alarms_cache_$uid';

  Future<void> cacheAlarms(String uid, List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString(_cacheKey(uid), encoded);
  }

  Future<List<Alarm>> getCachedAlarms(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey(uid));
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Alarm.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> clearCache(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey(uid));
  }
}
