import 'base_model.dart';

/// Payment data model
class Payment extends BaseModel {
  final String id;
  final String patientId;
  final String doctorId;
  final double amount;
  final String paymentMethod;
  final String status; // Paid, Pending, Failed
  final DateTime transactionDate;
  final String? transactionId;
  final String? invoiceUrl;

  Payment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.transactionDate,
    this.transactionId,
    this.invoiceUrl,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'doctorId': doctorId,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'status': status,
    'transactionDate': transactionDate.toIso8601String(),
    'transactionId': transactionId,
    'invoiceUrl': invoiceUrl,
  };

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] ?? '',
    patientId: json['patientId'] ?? '',
    doctorId: json['doctorId'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    paymentMethod: json['paymentMethod'] ?? '',
    status: json['status'] ?? 'Pending',
    transactionDate: DateTime.tryParse(json['transactionDate'] ?? '') ?? DateTime.now(),
    transactionId: json['transactionId'],
    invoiceUrl: json['invoiceUrl'],
  );
}
