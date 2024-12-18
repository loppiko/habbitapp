class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (statusCode: $statusCode)';
}

class AuthenticationException extends ApiException {
  AuthenticationException(String message) : super(message);
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}
