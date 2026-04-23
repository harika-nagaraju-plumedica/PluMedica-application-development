import 'package:get/get.dart';

/// Model for patient history
class PatientHistoryItem {
  final String patientId;
  final String patientName;
  final String diagnosis;
  final String prescriptions;
  final String testReports;
  final String advice;
  final DateTime visitDate;

  PatientHistoryItem({
    required this.patientId,
    required this.patientName,
    required this.diagnosis,
    required this.prescriptions,
    required this.testReports,
    required this.advice,
    required this.visitDate,
  });
}

/// Controller for doctor patient history
class DoctorPatientHistoryController extends GetxController {
  final isLoading = false.obs;
  final patientHistoryList = <PatientHistoryItem>[].obs;
  final filteredHistoryList = <PatientHistoryItem>[].obs;

  final selectedPatient = Rx<String?>(null);
  final selectedYear = Rx<String?>(null);

  final patientList = <String>[].obs;
  final yearList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPatientHistory();
  }

  /// Load patient history
  Future<void> loadPatientHistory() async {
    isLoading.value = true;

    try {
      // TODO: API call to fetch patient history
      patientHistoryList.value = [
        PatientHistoryItem(
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          diagnosis: 'Hypertension',
          prescriptions: 'Amlodipine 5mg OD',
          testReports: 'BP: 140/90, Normal ECG',
          advice: 'Take medication regularly, reduce salt intake',
          visitDate: DateTime.now().subtract(const Duration(days: 10)),
        ),
        PatientHistoryItem(
          patientId: 'P2',
          patientName: 'Priya Singh',
          diagnosis: 'Type 2 Diabetes',
          prescriptions: 'Metformin 500mg BD',
          testReports: 'FBS: 180, HbA1c: 7.2',
          advice: 'Follow diet plan, exercise 30 min daily',
          visitDate: DateTime.now().subtract(const Duration(days: 20)),
        ),
        PatientHistoryItem(
          patientId: 'P3',
          patientName: 'Amit Patel',
          diagnosis: 'Coronary Artery Disease',
          prescriptions: 'Aspirin 75mg OD, Atorvastatin 20mg',
          testReports: 'Troponin: Negative, ECG: Normal',
          advice: 'Regular follow-up, avoid stress',
          visitDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
        PatientHistoryItem(
          patientId: 'P4',
          patientName: 'Kavita Sharma',
          diagnosis: 'Allergic Rhinitis',
          prescriptions: 'Cetirizine 10mg OD',
          testReports: 'Allergy panel: Dust mites positive',
          advice: 'Avoid allergens, use nasal saline',
          visitDate: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];

      // Build patient list
      patientList.value =
          patientHistoryList.map((p) => p.patientName).toSet().toList();

      // Build year list
      final years = <String>{};
      for (var item in patientHistoryList) {
        years.add(item.visitDate.year.toString());
      }
      yearList.value = years.toList()..sort((a, b) => b.compareTo(a));

      filteredHistoryList.value = patientHistoryList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load patient history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter by patient
  void filterByPatient(String? patientName) {
    selectedPatient.value = patientName;
    applyFilters();
  }

  /// Filter by year
  void filterByYear(String? year) {
    selectedYear.value = year;
    applyFilters();
  }

  /// Apply all filters
  void applyFilters() {
    filteredHistoryList.value = patientHistoryList.where((item) {
      bool patientMatch = true;
      bool yearMatch = true;

      if (selectedPatient.value != null) {
        patientMatch = item.patientName == selectedPatient.value;
      }

      if (selectedYear.value != null) {
        yearMatch = item.visitDate.year.toString() == selectedYear.value;
      }

      return patientMatch && yearMatch;
    }).toList();
  }

  /// Clear filters
  void clearFilters() {
    selectedPatient.value = null;
    selectedYear.value = null;
    filteredHistoryList.value = patientHistoryList;
  }
}
