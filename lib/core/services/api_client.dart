import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Base URL for the backend. Change this to your production URL before deploying.
/// For Android emulator use: http://10.0.2.2:5001/api
/// For iOS simulator use: http://localhost:5001/api
/// For physical device: use your machine's local IP, e.g. http://192.168.1.x:5001/api
const String kBaseUrl = 'https://api.koulini.in/api';

/// Key used to store the JWT in SharedPreferences.
const String kTokenKey = 'auth_token';

/// Unified result type returned by every service call.
class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;

  const ApiResult.ok(this.data) : success = true, error = null;

  const ApiResult.err(this.error) : success = false, data = null;
}

/// Low-level HTTP client that:
/// - Automatically attaches the stored JWT to every request.
/// - Parses JSON responses into maps.
/// - Returns a typed [ApiResult] instead of throwing exceptions.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // ─── Token helpers ─────────────────────────────────────────────────────────

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kTokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kTokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kTokenKey);
  }

  // ─── Request helpers ───────────────────────────────────────────────────────

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ─── Public HTTP methods ───────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$kBaseUrl$path'),
            headers: await _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _parse(response);
    } on SocketException {
      return const ApiResult.err(
        'No internet connection. Please check your network and try again.',
      );
    } on HttpException {
      return const ApiResult.err(
        'Could not reach the server. Please try again.',
      );
    } catch (e) {
      return ApiResult.err('Something went wrong: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> get(
    String path, {
    bool auth = true,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$kBaseUrl$path'), headers: await _headers(auth: auth))
          .timeout(const Duration(seconds: 15));

      return _parse(response);
    } on SocketException {
      return const ApiResult.err('No internet connection.');
    } catch (e) {
      return ApiResult.err('Something went wrong: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$kBaseUrl$path'),
            headers: await _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _parse(response);
    } on SocketException {
      return const ApiResult.err('No internet connection.');
    } catch (e) {
      return ApiResult.err('Something went wrong: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> delete(
    String path, {
    bool auth = true,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$kBaseUrl$path'),
            headers: await _headers(auth: auth),
          )
          .timeout(const Duration(seconds: 15));

      return _parse(response);
    } on SocketException {
      return const ApiResult.err('No internet connection.');
    } catch (e) {
      return ApiResult.err('Something went wrong: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> patch(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$kBaseUrl$path'),
            headers: await _headers(auth: auth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _parse(response);
    } on SocketException {
      return const ApiResult.err('No internet connection.');
    } catch (e) {
      return ApiResult.err('Something went wrong: $e');
    }
  }

  // ─── Response parser ───────────────────────────────────────────────────────

  ApiResult<Map<String, dynamic>> _parse(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResult.ok(json);
      }

      final message = json['message'] as String? ?? 'An error occurred.';
      return ApiResult.err(message);
    } catch (_) {
      return ApiResult.err(
        'Unexpected response from server (status ${response.statusCode}).',
      );
    }
  }
}
