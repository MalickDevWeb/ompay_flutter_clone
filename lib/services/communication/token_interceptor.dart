// lib/communication/token_interceptor.dart
import 'package:dio/dio.dart';

/// Basic interceptor to add authorization token
class TokenInterceptor extends Interceptor {
  final Future<String?> Function()? tokenProvider;

  TokenInterceptor({this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final authHeader = await tokenProvider?.call();
      if (authHeader != null && authHeader.isNotEmpty) {
        options.headers['Authorization'] = authHeader;
      }
    } catch (e) {
      // If token retrieval fails, continue without authorization
      print('Failed to retrieve auth token: $e');
    }
    super.onRequest(options, handler);
  }
}
