import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mella_mate_app/core/constants.dart';
import 'package:mella_mate_app/features/auth/data/datalayer/auth_remote_datasource.dart';
import 'package:mella_mate_app/features/auth/data/model/user_model.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String username, String password);
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<User?> getStoredUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final _storage = const FlutterSecureStorage();

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResponse> login(String username, String password) async {
    final response = await _remoteDataSource.login(username, password);
    
    // Persist token and user data
    await _storage.write(key: AppConstants.tokenKey, value: response.accessToken);
    await _storage.write(
      key: AppConstants.userKey, 
      value: jsonEncode(response.user.toJson())
    );
    
    return response;
  }

  @override
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    await _remoteDataSource.signup(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
    await _storage.delete(key: AppConstants.secretKey);
  }

  @override
  Future<User?> getStoredUser() async {
    final userData = await _storage.read(key: AppConstants.userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }
}
