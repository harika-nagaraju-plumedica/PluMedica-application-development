class GenericApiResponse<T> {
  const GenericApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
  });

  final bool success;
  final String message;
  final T? data;
  final String? errorCode;

  factory GenericApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic raw)? fromData,
  }) {
    final rawData = json['data'];

    return GenericApiResponse<T>(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: fromData == null ? rawData as T? : fromData(rawData),
      errorCode: json['errorCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
      'errorCode': errorCode,
    };
  }
}
