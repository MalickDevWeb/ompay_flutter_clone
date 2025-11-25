// lib/communication/token_interceptor.dart
import 'package:dio/dio.dart';

/// Basic interceptor to add authorization token
class TokenInterceptor extends Interceptor {
  final String? Function()? tokenProvider;

  TokenInterceptor({this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
