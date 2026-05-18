class DashboardModel {
  const DashboardModel({
    required this.patient,
    required this.summary,
    required this.latestMetrics,
  });

  final DashboardPatient patient;
  final DashboardSummary summary;
  final LatestMetrics latestMetrics;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      patient: DashboardPatient.fromJson(_asMap(json['patient'])),
      summary: DashboardSummary.fromJson(_asMap(json['summary'])),
      latestMetrics: LatestMetrics.fromJson(_asMap(json['latestMetrics'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'patient': patient.toJson(),
      'summary': summary.toJson(),
      'latestMetrics': latestMetrics.toJson(),
    };
  }
}

class DashboardPatient {
  const DashboardPatient({
    required this.id,
    required this.fullName,
    this.generatedId,
  });

  final String id;
  final String fullName;
  final String? generatedId;

  factory DashboardPatient.fromJson(Map<String, dynamic> json) {
    return DashboardPatient(
      id: _asString(json['id']),
      fullName: _asString(json['fullName']),
      generatedId: _asNullableString(json['generatedId']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'generatedId': generatedId,
    };
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.upcomingAppointments,
    required this.activeMedications,
    required this.reports,
  });

  final int upcomingAppointments;
  final int activeMedications;
  final int reports;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      upcomingAppointments: _asInt(json['upcomingAppointments']),
      activeMedications: _asInt(json['activeMedications']),
      reports: _asInt(json['reports']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'upcomingAppointments': upcomingAppointments,
      'activeMedications': activeMedications,
      'reports': reports,
    };
  }
}

class LatestMetrics {
  const LatestMetrics({
    this.bloodPressure,
    this.heartRate,
    this.weight,
    this.oxygenLevel,
  });

  final String? bloodPressure;
  final HeartRateMetric? heartRate;
  final double? weight;
  final double? oxygenLevel;

  factory LatestMetrics.fromJson(Map<String, dynamic> json) {
    return LatestMetrics(
      bloodPressure: _asNullableString(json['bloodPressure']),
      heartRate: json['heartRate'] is Map<String, dynamic>
          ? HeartRateMetric.fromJson(json['heartRate'] as Map<String, dynamic>)
          : null,
      weight: _asDoubleOrNull(json['weight']),
      oxygenLevel: _asDoubleOrNull(json['oxygenLevel']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bloodPressure': bloodPressure,
      'heartRate': heartRate?.toJson(),
      'weight': weight,
      'oxygenLevel': oxygenLevel,
    };
  }
}

class HeartRateMetric {
  const HeartRateMetric({
    required this.value,
    required this.unit,
    this.measuredAt,
  });

  final int value;
  final String unit;
  final String? measuredAt;

  factory HeartRateMetric.fromJson(Map<String, dynamic> json) {
    return HeartRateMetric(
      value: _asInt(json['value']),
      unit: _asString(json['unit']),
      measuredAt: json['measuredAt'] is String ? json['measuredAt'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'value': value,
      'unit': unit,
      'measuredAt': measuredAt,
    };
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return <String, dynamic>{};
}

String _asString(dynamic value) {
  final parsed = value?.toString().trim() ?? '';
  return parsed;
}

String? _asNullableString(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is Map && value.isEmpty) {
    return null;
  }
  final parsed = value.toString().trim();
  if (parsed.isEmpty || parsed == '{}' || parsed.toLowerCase() == 'null') {
    return null;
  }
  return parsed;
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double? _asDoubleOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  final parsed = double.tryParse(value.toString());
  return parsed;
}
