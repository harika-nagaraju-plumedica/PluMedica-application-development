class HealthMetric {
  const HealthMetric({
    required this.id,
    required this.metricType,
    required this.value,
    required this.unit,
    this.measuredAt,
    this.source,
  });

  final String id;
  final double value;
  final String metricType;
  final String unit;
  final String? measuredAt;
  final String? source;

  factory HealthMetric.fromJson(Map<String, dynamic> json) {
    return HealthMetric(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      metricType: (json['metricType'] ?? '').toString(),
      value: _toDouble(json['value']),
      unit: (json['unit'] ?? '').toString(),
      measuredAt: _safeDate(json['measuredAt']),
      source: json['source']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'metricType': metricType,
      'value': value,
      'unit': unit,
      'measuredAt': measuredAt,
      'source': source,
    };
  }
}

class AddHealthMetricRequest {
  const AddHealthMetricRequest({
    required this.metricType,
    required this.value,
    required this.unit,
    required this.measuredAt,
    required this.source,
  });

  final String metricType;
  final double value;
  final String unit;
  final String measuredAt;
  final String source;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'metricType': metricType,
      'value': value,
      'unit': unit,
      'measuredAt': measuredAt,
      'source': source,
    };
  }
}

double _toDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String? _safeDate(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is Map && value.isEmpty) {
    return null;
  }
  final raw = value.toString().trim();
  if (raw.isEmpty || raw == '{}' || raw.toLowerCase() == 'null') {
    return null;
  }
  return raw;
}
