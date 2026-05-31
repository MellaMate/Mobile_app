import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/auth/data/model/user_model.dart';
import 'package:mella_mate_app/features/auth/data/repository/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository) {
    _init();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> _init() async {
    _user = await _authRepository.getStoredUser();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _authRepository.login(username, password);
      _user = response.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      await _authRepository.signup(
        username: username,
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
