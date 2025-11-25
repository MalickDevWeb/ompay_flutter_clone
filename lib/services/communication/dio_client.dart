import 'package:dio/dio.dart';
import '../../core/utils/api_executor.dart';
import '../../core/abstracts/api_client.dart';
import '../../core/models/api_result.dart';
import '../../core/config/app_config.dart';
import '../auth_service.dart';
import 'token_interceptor.dart';

/// Implementation of ApiClient using the Dio library for HTTP requests.
/// Supports timeouts and environment-based base URL configuration.
class DioClient implements ApiClient {
  late final Dio dio;

  DioClient({String? baseUrl, Dio? dioInstance, AuthService? authService}) {
    dio = dioInstance ?? Dio(BaseOptions(
      baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: 89),
      receiveTimeout: Duration(seconds: 120), // 2 minutes for slow backend
    ));

    // Add token interceptor for authentication
    dio.interceptors.add(TokenInterceptor(
      tokenProvider: () => (authService ?? AuthService()).accessToken,
    ));
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> get(String url) => ApiExecutor.execute(() => dio.get(url).then((res) => res.data));

  @override
  Future<ApiResult<Map<String, dynamic>>> post(String url, Map<String, dynamic> body) => ApiExecutor.execute(() => dio.post(url, data: body).then((res) => res.data));

  @override
  Future<ApiResult<Map<String, dynamic>>> put(String url, Map<String, dynamic> body) => ApiExecutor.execute(() => dio.put(url, data: body).then((res) => res.data));

  @override
  Future<ApiResult<Map<String, dynamic>>> patch(String url, Map<String, dynamic> body) => ApiExecutor.execute(() => dio.patch(url, data: body).then((res) => res.data));

  @override
  Future<ApiResult<Map<String, dynamic>>> delete(String url) => ApiExecutor.execute(() => dio.delete(url).then((res) => res.data));
}
