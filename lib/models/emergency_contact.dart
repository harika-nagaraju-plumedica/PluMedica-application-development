class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.patientId,
    required this.name,
    required this.relation,
    required this.phone,
    this.email,
    required this.priority,
    required this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String patientId;
  final String name;
  final String relation;
  final String phone;
  final String? email;
  final int priority;
  final bool isPrimary;
  final String? createdAt;
  final String? updatedAt;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      // Required parsing rule for Mongo object ids.
      id: json['_id'] is Map<String, dynamic>
          ? (json['_id'] as Map<String, dynamic>)['buffer']?.toString() ?? ''
          : (json['_id'] ?? json['id'] ?? '').toString(),
      patientId: json['patientId'] is Map<String, dynamic>
          ? (json['patientId'] as Map<String, dynamic>)['buffer']?.toString() ?? ''
          : (json['patientId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      relation: (json['relation'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: _safeNullableString(json['email']),
      priority: _toInt(json['priority']),
      isPrimary: json['isPrimary'] == true,
      createdAt: _safeNullableString(json['createdAt']),
      updatedAt: _safeNullableString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patientId': patientId,
      'name': name,
      'relation': relation,
      'phone': phone,
      'email': email,
      'priority': priority,
      'isPrimary': isPrimary,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CreateEmergencyContactRequest {
  const CreateEmergencyContactRequest({
    required this.name,
    required this.relation,
    required this.phone,
    this.email,
    required this.priority,
    required this.isPrimary,
  });

  final String name;
  final String relation;
  final String phone;
  final String? email;
  final int priority;
  final bool isPrimary;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'relation': relation,
      'phone': phone,
      'email': email,
      'priority': priority,
      'isPrimary': isPrimary,
    };
  }
}

String? _safeNullableString(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  if (text.isEmpty || text == '{}') {
    return null;
  }
  return text;
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
