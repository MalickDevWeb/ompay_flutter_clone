/// Represents the result of an API call, either success with data or failure with error.
class ApiResult<T> {
  /// The data received if the request was successful.
  final T? data;

  /// The error message if the request failed.
  final String? error;

  /// Optional HTTP status code.
  final int? statusCode;

  ApiResult({this.data, this.error, this.statusCode});

  /// Returns true if the result is successful (has data and no error).
  bool get isSuccess => data != null && error == null;

  /// Returns true if the result is an error (has error).
  bool get isError => error != null;

  /// Factory to create a successful result.
  factory ApiResult.success(T data, [int? statusCode]) =>
      ApiResult(data: data, statusCode: statusCode);

  /// Factory to create a failure result.
  factory ApiResult.failure(String error, [int? statusCode]) =>
      ApiResult(error: error, statusCode: statusCode);
}
