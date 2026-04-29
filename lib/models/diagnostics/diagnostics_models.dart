class DiagnosticsRequest {
  String patientName;
  String patientId;
  String doctorName;
  String source;
  String testRequested;
  String status;
  String mobile;
  String date;

  DiagnosticsRequest({
    required this.patientName,
    required this.patientId,
    required this.doctorName,
    required this.source,
    required this.testRequested,
    required this.status,
    required this.mobile,
    required this.date,
  });
}

class DiagnosticsActivity {
  final String time;
  final String event;

  const DiagnosticsActivity({
    required this.time,
    required this.event,
  });
}
