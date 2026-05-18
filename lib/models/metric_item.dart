class MetricItem {
  const MetricItem({
    required this.id,
    required this.metricType,
    required this.value,
    required this.unit,
    this.measuredAt,
    this.source,
  });

  final String id;
  final String metricType;
  final double value;
  final String unit;
  final String? measuredAt;
  final String? source;

  factory MetricItem.fromJson(Map<String, dynamic> json) {
    return MetricItem(
      // Required parsing rule for Mongo object ids.
      id: json['_id'] is Map<String, dynamic>
          ? (json['_id'] as Map<String, dynamic>)['buffer']?.toString() ?? ''
          : (json['_id'] ?? json['id'] ?? '').toString(),
      metricType: (json['metricType'] ?? '').toString(),
      value: _toDouble(json['value']),
      unit: (json['unit'] ?? '').toString(),
      // Required parsing rule for mixed measuredAt values.
      measuredAt: json['measuredAt'] is String
          ? (json['measuredAt'] as String).trim().isEmpty
              ? null
              : (json['measuredAt'] as String).trim()
          : null,
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

double _toDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
