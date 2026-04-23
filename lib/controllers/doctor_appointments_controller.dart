import 'package:get/get.dart';
import '../models/appointment_model.dart';

/// Controller for doctor appointments
class DoctorAppointmentsController extends GetxController {
  final isLoading = false.obs;
  final pendingAppointments = <Appointment>[].obs;
  final completedAppointments = <Appointment>[].obs;
  final selectedTab = 'Pending'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  /// Load appointments
  Future<void> loadAppointments() async {
    isLoading.value = true;

    try {
      // TODO: API call to fetch appointments
      // Load pending appointments
      pendingAppointments.value = [
        Appointment(
          id: '1',
          doctorId: '1',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          mode: 'Virtual',
          appointmentDate: DateTime.now().add(const Duration(days: 1)),
          timeSlot: '10:00 AM - 10:30 AM',
          status: 'Pending',
          reason: 'Follow-up consultation',
          createdAt: DateTime.now(),
        ),
        Appointment(
          id: '2',
          doctorId: '1',
          patientId: 'P2',
          patientName: 'Priya Singh',
          mode: 'In-Person',
          appointmentDate: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '02:00 PM - 02:30 PM',
          status: 'Pending',
          reason: 'General checkup',
          createdAt: DateTime.now(),
        ),
        Appointment(
          id: '3',
          doctorId: '1',
          patientId: 'P3',
          patientName: 'Amit Patel',
          mode: 'Virtual',
          appointmentDate: DateTime.now().add(const Duration(days: 3)),
          timeSlot: '03:30 PM - 04:00 PM',
          status: 'Pending',
          reason: 'Heart checkup',
          createdAt: DateTime.now(),
        ),
      ];

      // Load completed appointments
      completedAppointments.value = [
        Appointment(
          id: '4',
          doctorId: '1',
          patientId: 'P4',
          patientName: 'Kavita Sharma',
          mode: 'Virtual',
          appointmentDate: DateTime.now().subtract(const Duration(days: 1)),
          timeSlot: '11:00 AM - 11:30 AM',
          status: 'Completed',
          notes: 'Patient doing well, advised rest and medication',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Appointment(
          id: '5',
          doctorId: '1',
          patientId: 'P5',
          patientName: 'Suresh Gupta',
          mode: 'In-Person',
          appointmentDate: DateTime.now().subtract(const Duration(days: 3)),
          timeSlot: '02:30 PM - 03:00 PM',
          status: 'Completed',
          notes: 'Treatment successful, discharged',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load appointments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch tab
  void switchTab(String tab) {
    selectedTab.value = tab;
  }

  /// Mark appointment as completed
  void markAsCompleted(Appointment appointment) {
    // TODO: API call to update appointment status
    final index = pendingAppointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      final updatedAppointment = Appointment(
        id: appointment.id,
        doctorId: appointment.doctorId,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
        mode: appointment.mode,
        appointmentDate: appointment.appointmentDate,
        timeSlot: appointment.timeSlot,
        status: 'Completed',
        reason: appointment.reason,
        notes: 'Appointment completed',
        createdAt: appointment.createdAt,
      );
      pendingAppointments.removeAt(index);
      completedAppointments.add(updatedAppointment);
    }

    Get.snackbar(
      'Success',
      'Appointment marked as completed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Refresh appointments
  Future<void> refreshAppointments() async {
    await loadAppointments();
  }
}
