import 'package:mella_mate_app/core/api_client.dart';
import 'package:mella_mate_app/core/constants.dart';
import 'package:mella_mate_app/features/auth/data/model/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<AuthResponse> login(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
    };

    final response = await _apiClient.post(
      AppConstants.loginEndpoint,
      body: body,
      requireAuth: false,
      isFormData: true,
    );

    return AuthResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = username.trim();
    final body = {
      'username': normalizedEmail,
      'full_name': normalizedName,
      'email': normalizedEmail,
      'password': password,
      'role': role,
    };

    final response = await _apiClient.post(
      AppConstants.signupEndpoint,
      body: body,
      requireAuth: false,
    );

    return response;
  }
}
