import 'package:get/get.dart';

class PatientHealthRecordsController extends GetxController {
  final isLoading = false.obs;
  final healthRecords = <Map<String, dynamic>>[].obs;
  final selectedRecord = Rx<dynamic>(null);
  int _uploadSeed = 1;

  @override
  void onInit() {
    super.onInit();
    loadHealthRecords();
  }

  Future<void> loadHealthRecords() async {
    isLoading.value = true;
    try {
      healthRecords.assignAll([
        {
          'id': 'HR-1001',
          'title': 'CBC Lab Report',
          'date': 'Apr 26, 2026',
          'type': 'pdf',
          'doctorName': 'Nisha Verma',
        },
        {
          'id': 'HR-1002',
          'title': 'Blood Pressure Follow-up Note',
          'date': 'Apr 24, 2026',
          'type': 'doc',
          'doctorName': 'Priya Sharma',
        },
        {
          'id': 'HR-1003',
          'title': 'Chest X-Ray Result',
          'date': 'Apr 21, 2026',
          'type': 'image',
          'doctorName': 'Amit Patel',
        },
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health records');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadRecord(String recordId) async {
    final record = healthRecords.firstWhereOrNull((r) => r['id'] == recordId);
    if (record == null) {
      return;
    }
    Get.snackbar(
      'Download Started',
      '${record['title']} is being downloaded.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> shareRecord(String recordId) async {
    final record = healthRecords.firstWhereOrNull((r) => r['id'] == recordId);
    if (record == null) {
      return;
    }
    Get.snackbar(
      'Share Record',
      '${record['title']} ready to share.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> viewRecord(String recordId) async {
    final record = healthRecords.firstWhereOrNull((r) => r['id'] == recordId);
    if (record == null) {
      return;
    }
    selectedRecord.value = record;
    Get.snackbar(
      record['title'] as String,
      'Date: ${record['date']} | Doctor: ${record['doctorName']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadRecord() async {
    final now = DateTime.now();
    final formattedDate =
        '${_monthShort(now.month)} ${now.day.toString().padLeft(2, '0')}, ${now.year}';

    final newRecord = <String, dynamic>{
      'id': 'HR-UP-${now.millisecondsSinceEpoch}',
      'title': 'Uploaded Document $_uploadSeed',
      'date': formattedDate,
      'type': 'pdf',
      'doctorName': 'Self Upload',
    };

    _uploadSeed++;
    healthRecords.insert(0, newRecord);
    Get.snackbar(
      'Upload Successful',
      '${newRecord['title']} added to health records.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _monthShort(int month) {
    const monthMap = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthMap[month - 1];
  }
}
