class NotifiedContact {
  const NotifiedContact({
    required this.id,
    required this.name,
    required this.phone,
  });

  final String id;
  final String name;
  final String phone;

  factory NotifiedContact.fromJson(Map<String, dynamic> json) {
    return NotifiedContact(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class SOSResponse {
  const SOSResponse({
    required this.alertId,
    required this.status,
    required this.notifiedContacts,
  });

  final String alertId;
  final String status;
  final List<NotifiedContact> notifiedContacts;

  factory SOSResponse.fromJson(Map<String, dynamic> json) {
    final rawContacts = json['notifiedContacts'] is List
        ? json['notifiedContacts'] as List<dynamic>
        : <dynamic>[];

    return SOSResponse(
      alertId: (json['alertId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      notifiedContacts: rawContacts
          .whereType<Map<String, dynamic>>()
          .map(NotifiedContact.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'alertId': alertId,
      'status': status,
      'notifiedContacts': notifiedContacts.map((e) => e.toJson()).toList(),
    };
  }
}
