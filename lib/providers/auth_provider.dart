import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final Map<String, String> _users = {};
  String? _currentUserEmail;

  bool get isLoggedIn => _currentUserEmail != null;
  String? get currentUserEmail => _currentUserEmail;

  String? signUp(String email, String password) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_users.containsKey(trimmedEmail)) {
      return 'An account with this email already exists.';
    }

    _users[trimmedEmail] = password;
    _currentUserEmail = trimmedEmail;
    notifyListeners();
    return null;
  }

  String? login(String email, String password) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }

    final storedPassword = _users[trimmedEmail];
    if (storedPassword == null || storedPassword != password) {
      return 'Invalid email or password.';
    }

    _currentUserEmail = trimmedEmail;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUserEmail = null;
    notifyListeners();
  }
}
