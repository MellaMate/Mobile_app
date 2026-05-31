import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final http.Client _client = http.Client();
  final _storage = const FlutterSecureStorage();
  final _logger = Logger();

  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _storage.read(key: AppConstants.tokenKey);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      
      _logger.i('GET Request: $url');
      final response = await _client.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      _logger.e('GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body, bool requireAuth = true, bool isFormData = false}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      
      if (isFormData) {
        headers['Content-Type'] = 'application/x-www-form-urlencoded';
      }

      _logger.i('POST Request: $url');
      final response = await _client.post(
        url,
        headers: headers,
        body: isFormData ? body : jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      _logger.e('POST Error: $e');
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['detail'] ?? 'An error occurred';
      _logger.w('API Error (${response.statusCode}): $message');
      throw Exception(message);
    }
  }
}
