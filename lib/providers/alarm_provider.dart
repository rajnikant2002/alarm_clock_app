import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/alarm.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class AlarmProvider extends ChangeNotifier {
  AlarmProvider(
    this._firebaseService,
    this._localStorageService,
    this._notificationService,
  );

  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;
  final NotificationService _notificationService;

  final List<Alarm> _alarms = [];
  StreamSubscription<List<Alarm>>? _subscription;
  String? _listeningUid;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Alarm> get alarms => List.unmodifiable(_alarms);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> listenToAlarms(String uid, {bool force = false}) async {
    if (!force && _listeningUid == uid && _subscription != null) return;

    _subscription?.cancel();
    _listeningUid = uid;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cached = await _localStorageService.getCachedAlarms(uid);
    if (cached.isNotEmpty) {
      _alarms
        ..clear()
        ..addAll(cached);
      notifyListeners();
    }

    _subscription = _firebaseService.watchAlarms(uid).listen(
      (alarms) async {
        _alarms
          ..clear()
          ..addAll(alarms);
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();

        await _localStorageService.cacheAlarms(uid, alarms);
        await _notificationService.syncAlarms(alarms);
      },
      onError: (Object error) async {
        _subscription?.cancel();
        _subscription = null;
        _listeningUid = null;
        _isLoading = false;

        if (_alarms.isEmpty) {
          final fallback = await _localStorageService.getCachedAlarms(uid);
          _alarms
            ..clear()
            ..addAll(fallback);
        }

        _errorMessage = _mapError(error);
        notifyListeners();
      },
    );
  }

  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _listeningUid = null;
    _alarms.clear();
    _isLoading = false;
    _isSaving = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<String?> addAlarm({
    required String uid,
    required String label,
    required int hour,
    required int minute,
  }) async {
    final alarm = Alarm(
      id: _firebaseService.generateAlarmId(uid),
      label: label,
      hour: hour,
      minute: minute,
    );

    final error = await _runSave(() => _firebaseService.addAlarm(uid, alarm));
    if (error == null) {
      await _upsertAlarm(uid, alarm);
    }
    return error;
  }

  Future<String?> updateAlarm({
    required String uid,
    required Alarm alarm,
    required String label,
    required int hour,
    required int minute,
  }) async {
    final updated = alarm.copyWith(
      label: label,
      hour: hour,
      minute: minute,
    );

    final error =
        await _runSave(() => _firebaseService.updateAlarm(uid, updated));
    if (error == null) {
      await _upsertAlarm(uid, updated);
    }
    return error;
  }

  Future<String?> toggleAlarm({
    required String uid,
    required String alarmId,
    required bool isEnabled,
  }) async {
    try {
      await _firebaseService.toggleAlarm(uid, alarmId, isEnabled);
      final index = _alarms.indexWhere((alarm) => alarm.id == alarmId);
      if (index >= 0) {
        final updated = _alarms[index].copyWith(isEnabled: isEnabled);
        _alarms[index] = updated;
        notifyListeners();
        await _localStorageService.cacheAlarms(uid, _alarms);
        if (isEnabled) {
          await _notificationService.scheduleAlarm(updated);
        } else {
          await _notificationService.cancelAlarm(alarmId);
        }
      }
      return null;
    } catch (error) {
      _errorMessage = _mapError(error);
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<String?> deleteAlarm({
    required String uid,
    required String alarmId,
  }) async {
    try {
      await _firebaseService.deleteAlarm(uid, alarmId);
      _alarms.removeWhere((alarm) => alarm.id == alarmId);
      notifyListeners();
      await _localStorageService.cacheAlarms(uid, _alarms);
      await _notificationService.cancelAlarm(alarmId);
      return null;
    } catch (error) {
      _errorMessage = _mapError(error);
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<void> _upsertAlarm(String uid, Alarm alarm) async {
    final index = _alarms.indexWhere((item) => item.id == alarm.id);
    if (index >= 0) {
      _alarms[index] = alarm;
    } else {
      _alarms.add(alarm);
    }
    Alarm.sortList(_alarms);
    notifyListeners();

    await _localStorageService.cacheAlarms(uid, _alarms);
    if (alarm.isEnabled) {
      await _notificationService.scheduleAlarm(alarm);
    } else {
      await _notificationService.cancelAlarm(alarm.id);
    }
  }

  Future<String?> _runSave(Future<void> Function() action) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      return null;
    } catch (error) {
      _errorMessage = _mapError(error);
      return _errorMessage;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String _mapError(Object error) {
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return 'Permission denied. Check your Firestore security rules.';
      }
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        return 'Network error. Check your internet connection.';
      }
      return error.message ?? 'Failed to sync alarms.';
    }
    return 'Something went wrong. Please try again.';
  }
}
