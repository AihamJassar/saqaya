import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitializing = true;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _user != null;

  UserProvider() {
    // Listen to auth state changes on initialization
    _authService.userStream.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getCurrentUser();
      } else {
        _user = null;
      }
      _isInitializing = false;
      notifyListeners();
    });
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
