enum PatientApiErrorType {
  badRequest,
  unauthorized,
  server,
  timeout,
  network,
  parsing,
  unknown,
}

class PatientApiException implements Exception {
  const PatientApiException({
    required this.message,
    this.statusCode,
    this.type = PatientApiErrorType.unknown,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final PatientApiErrorType type;
  final Object? cause;

  @override
  String toString() {
    final status = statusCode == null ? '' : ' [status: $statusCode]';
    return '$message$status';
  }
}
