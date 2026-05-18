class ApiResponse<T> {
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
  });

  final bool success;
  final String message;
  final T? data;
  final String? errorCode;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic raw)? dataParser,
  }) {
    return ApiResponse<T>(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: dataParser == null ? json['data'] as T? : dataParser(json['data']),
      errorCode: json['errorCode']?.toString(),
    );
  }
}

class RegistrationData {
  RegistrationData({
    required this.profile,
    this.token,
  });

  final Map<String, dynamic> profile;
  final String? token;

  factory RegistrationData.fromJson(dynamic raw) {
    final map = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    return RegistrationData(
      profile: (map['profile'] is Map<String, dynamic>)
          ? map['profile'] as Map<String, dynamic>
          : <String, dynamic>{},
      token: map['token']?.toString(),
    );
  }
}
