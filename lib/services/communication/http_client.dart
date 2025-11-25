import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/utils/api_executor.dart';
import '../../core/abstracts/api_client.dart';
import '../../core/models/api_result.dart';
import '../../core/config/env_config.dart';
import '../auth_service.dart';

/// Implementation of ApiClient using the http package for HTTP requests.
/// Includes status code validation, timeouts, and environment-based base URL.
class HttpClientImpl implements ApiClient {
  final String baseUrl;
  final Logger logger = Logger('HttpClient');
  final AuthService authService;

  HttpClientImpl({String? baseUrl, AuthService? authService})
      : baseUrl = baseUrl ?? EnvConfig.get('API_BASE_URL', defaultValue: "http://localhost:8000/api"),
        authService = authService ?? AuthService();

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (authService.accessToken != null && authService.accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${authService.accessToken!}';
    }
    print('🔑 HttpClient headers: $headers');
    return headers;
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> get(String url) =>
      ApiExecutor.execute(() async {
        final response = await http.get(Uri.parse(baseUrl + url), headers: _headers).timeout(Duration(seconds: 10));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else {
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> post(String url, Map<String, dynamic> body) => ApiExecutor.execute(() async {
    final response = await http.post(
      Uri.parse(baseUrl + url),
      body: jsonEncode(body),
      headers: _headers,
    ).timeout(Duration(seconds: 10));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  });

  @override
  Future<ApiResult<Map<String, dynamic>>> put(String url, Map<String, dynamic> body) => ApiExecutor.execute(() async {
    final response = await http.put(
      Uri.parse(baseUrl + url),
      body: jsonEncode(body),
      headers: _headers,
    ).timeout(Duration(seconds: 10));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  });

  @override
  Future<ApiResult<Map<String, dynamic>>> patch(String url, Map<String, dynamic> body) => ApiExecutor.execute(() async {
    final response = await http.patch(
      Uri.parse(baseUrl + url),
      body: jsonEncode(body),
      headers: _headers,
    ).timeout(Duration(seconds: 10));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  });

  @override
  Future<ApiResult<Map<String, dynamic>>> delete(String url) =>
      ApiExecutor.execute(() async {
        final response = await http.delete(Uri.parse(baseUrl + url), headers: _headers).timeout(Duration(seconds: 10));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else {
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
      });
}
