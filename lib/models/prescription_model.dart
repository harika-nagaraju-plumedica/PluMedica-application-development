import 'base_model.dart';

class DrugEntry {
  final String drugName;
  final String dosage;
  final int durationDays;
  final bool morning;
  final bool afternoon;
  final bool night;
  final String instructions;

  const DrugEntry({
    required this.drugName,
    required this.dosage,
    required this.durationDays,
    required this.morning,
    required this.afternoon,
    required this.night,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'drugName': drugName,
    'dosage': dosage,
    'durationDays': durationDays,
    'morning': morning,
    'afternoon': afternoon,
    'night': night,
    'instructions': instructions,
  };

  factory DrugEntry.fromJson(Map<String, dynamic> json) => DrugEntry(
    drugName: json['drugName'] ?? '',
    dosage: json['dosage'] ?? '',
    durationDays: json['durationDays'] ?? 0,
    morning: json['morning'] ?? false,
    afternoon: json['afternoon'] ?? false,
    night: json['night'] ?? false,
    instructions: json['instructions'] ?? '',
  );
}

/// Prescription data model
class Prescription extends BaseModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String patientName;
  final List<DrugEntry> drugEntries;
  final String remarks;
  final DateTime createdAt;
  final DateTime? expiryDate;

  Prescription({
    required this.id,
    required this.doctorId,
    this.doctorName = 'Doctor',
    required this.patientId,
    this.patientName = '',
    this.drugEntries = const [],
    this.remarks = '',
    required this.createdAt,
    this.expiryDate,
  });

  // Backward-compatibility getters for existing UI references.
  String get medicationName => drugEntries.isEmpty ? '' : drugEntries.first.drugName;
  String get dosage => drugEntries.isEmpty ? '' : drugEntries.first.dosage;
  String get frequency {
    if (drugEntries.isEmpty) {
      return '';
    }
    final entry = drugEntries.first;
    final timings = <String>[];
    if (entry.morning) timings.add('Morning');
    if (entry.afternoon) timings.add('Afternoon');
    if (entry.night) timings.add('Night');
    return timings.join(' / ');
  }

  int get duration => drugEntries.isEmpty ? 0 : drugEntries.first.durationDays;
  String get instructions => drugEntries.isEmpty ? '' : drugEntries.first.instructions;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'patientId': patientId,
    'patientName': patientName,
    'drugEntries': drugEntries.map((entry) => entry.toJson()).toList(),
    'remarks': remarks,
    'createdAt': createdAt.toIso8601String(),
    'expiryDate': expiryDate?.toIso8601String(),
  };

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
    id: json['id'] ?? '',
    doctorId: json['doctorId'] ?? '',
    doctorName: json['doctorName'] ?? 'Doctor',
    patientId: json['patientId'] ?? '',
    patientName: json['patientName'] ?? '',
    drugEntries: json['drugEntries'] != null
        ? (json['drugEntries'] as List)
              .map((entry) => DrugEntry.fromJson(Map<String, dynamic>.from(entry)))
              .toList()
        : [
            DrugEntry(
              drugName: json['medicationName'] ?? '',
              dosage: json['dosage'] ?? '',
              durationDays: json['duration'] ?? 0,
              morning: (json['frequency'] ?? '').toString().contains('Morning') ||
                  (json['frequency'] ?? '').toString().contains('Once'),
              afternoon: (json['frequency'] ?? '').toString().contains('Afternoon') ||
                  (json['frequency'] ?? '').toString().contains('Twice') ||
                  (json['frequency'] ?? '').toString().contains('Thrice'),
              night: (json['frequency'] ?? '').toString().contains('Night') ||
                  (json['frequency'] ?? '').toString().contains('Thrice'),
              instructions: json['instructions'] ?? '',
            ),
          ],
    remarks: json['remarks'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    expiryDate: json['expiryDate'] != null ? DateTime.tryParse(json['expiryDate']) : null,
  );
}
