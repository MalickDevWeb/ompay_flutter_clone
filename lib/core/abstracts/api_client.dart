import '../models/api_result.dart';

/// Abstract interface for API clients to perform HTTP requests.
/// Implementations should hyandle network calls and return ApiResult.
abstract class ApiClient {
  /// Performs a GET request to the specified URL.
  Future<ApiResult<Map<String, dynamic>>> get(String url);

  /// Performs a POST request to the specified URL with the given body.
  Future<ApiResult<Map<String, dynamic>>> post(
    String url,
    Map<String, dynamic> body,
  );

  /// Performs a PUT request to the specified URL with the given body.
  Future<ApiResult<Map<String, dynamic>>> put(
    String url,
    Map<String, dynamic> body,
  );

  /// Performs a DELETE request to the specified URL.
  Future<ApiResult<Map<String, dynamic>>> delete(String url);

  /// Performs a PATCH request to the specified URL with the given body.
  Future<ApiResult<Map<String, dynamic>>> patch(
    String url,
    Map<String, dynamic> body,
  );
}
