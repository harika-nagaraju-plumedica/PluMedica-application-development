class MedicalHistory {
  const MedicalHistory({
    required this.appointments,
    required this.medications,
    required this.reports,
    required this.meta,
  });

  final List<Appointment> appointments;
  final List<dynamic> medications;
  final List<dynamic> reports;
  final Meta meta;

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    final appointmentsRaw = json['appointments'] is List
        ? json['appointments'] as List<dynamic>
        : json['items'] is List
            ? json['items'] as List<dynamic>
            : <dynamic>[];

    return MedicalHistory(
      appointments: appointmentsRaw
          .whereType<Map<String, dynamic>>()
          .map(Appointment.fromJson)
          .toList(),
      medications: json['medications'] is List
          ? json['medications'] as List<dynamic>
          : <dynamic>[],
      reports: json['reports'] is List
          ? json['reports'] as List<dynamic>
          : <dynamic>[],
      meta: Meta.fromJson(
        json['meta'] is Map<String, dynamic>
            ? json['meta'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appointments': appointments.map((e) => e.toJson()).toList(),
      'medications': medications,
      'reports': reports,
      'meta': meta.toJson(),
    };
  }
}

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorId,
    this.slotStart,
    this.slotEnd,
    required this.reason,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String doctorId;
  final String? slotStart;
  final String? slotEnd;
  final String reason;
  final String status;
  final String? createdAt;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: _parseObjectId(json['_id']),
      doctorId: _parseObjectId(json['doctorId']),
      slotStart: _safeDateString(json['slotStart']),
      slotEnd: _safeDateString(json['slotEnd']),
      reason: (json['reason'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: _safeDateString(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'doctorId': doctorId,
      'slotStart': slotStart,
      'slotEnd': slotEnd,
      'reason': reason,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class Meta {
  const Meta({
    required this.page,
    required this.limit,
    required this.type,
    this.total,
  });

  final int page;
  final int limit;
  final String type;
  final int? total;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: _asInt(json['page']),
      limit: _asInt(json['limit']),
      type: (json['type'] ?? '').toString(),
      total: json['total'] == null ? null : _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'type': type,
      'total': total,
    };
  }
}

String _parseObjectId(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    return value;
  }

  if (value is Map<String, dynamic>) {
    if (value['buffer'] != null) {
      return value['buffer'].toString();
    }
    if (value[r'$oid'] != null) {
      return value[r'$oid'].toString();
    }
    if (value.isEmpty) {
      return '';
    }
  }

  return value.toString();
}

String? _safeDateString(dynamic value) {
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

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
