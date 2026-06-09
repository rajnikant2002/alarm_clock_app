import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._firebaseService) {
    _firebaseService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseService _firebaseService;

  User? _user;
  bool _isLoading = false;

  bool get isLoggedIn => _user != null;
  String? get currentUserId => _user?.uid;
  String? get currentUserEmail => _user?.email;
  bool get isLoading => _isLoading;

  Future<String?> signUp(String email, String password) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return _runAuth(
      () => _firebaseService.signUp(email: trimmedEmail, password: password),
    );
  }

  Future<String?> login(String email, String password) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }

    return _runAuth(
      () => _firebaseService.signIn(email: trimmedEmail, password: password),
    );
  }

  Future<void> logout() => _firebaseService.signOut();

  Future<String?> _runAuth(Future<UserCredential> Function() action) async {
    _isLoading = true;
    notifyListeners();

    try {
      await action();
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
