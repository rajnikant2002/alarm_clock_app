import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/alarm.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  CollectionReference<Map<String, dynamic>> _alarmsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('alarms');
  }

  String generateAlarmId(String uid) {
    return _alarmsRef(uid).doc().id;
  }

  Stream<List<Alarm>> watchAlarms(String uid) {
    return _alarmsRef(uid).snapshots().map((snapshot) {
      final alarms = snapshot.docs
          .map((doc) => Alarm.fromFirestore(doc.id, doc.data()))
          .toList();
      Alarm.sortList(alarms);
      return alarms;
    });
  }

  Future<void> addAlarm(String uid, Alarm alarm) {
    return _alarmsRef(uid).doc(alarm.id).set(alarm.toMap());
  }

  Future<void> updateAlarm(String uid, Alarm alarm) {
    return _alarmsRef(uid).doc(alarm.id).update(alarm.toMapForUpdate());
  }

  Future<void> toggleAlarm(String uid, String alarmId, bool isEnabled) {
    return _alarmsRef(uid).doc(alarmId).update({'isEnabled': isEnabled});
  }

  Future<void> deleteAlarm(String uid, String alarmId) {
    return _alarmsRef(uid).doc(alarmId).delete();
  }
}
