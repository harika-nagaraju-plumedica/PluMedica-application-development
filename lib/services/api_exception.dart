class ApiException implements Exception {
  ApiException({
    required this.message,
    this.errorCode,
    this.statusCode,
    this.cause,
  });

  final String message;
  final String? errorCode;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() {
    final code = errorCode == null ? '' : ' (code: $errorCode)';
    final status = statusCode == null ? '' : ' [status: $statusCode]';
    return '$message$code$status';
  }
}
