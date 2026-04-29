import 'package:get/get.dart';

import '../models/appointment_model.dart';
import '../models/follow_up_model.dart';
import '../models/prescription_model.dart';
import '../models/referral_model.dart';

class ClinicalDataService extends GetxService {
  final appointments = <Appointment>[].obs;
  final rescheduleRequests = <String, Map<String, dynamic>>{}.obs;
  final prescriptions = <Prescription>[].obs;
  final followUps = <FollowUpRecord>[].obs;
  final referrals = <DoctorReferral>[].obs;

  // Minimal in-memory doctor directory for doctor selection/filtering.
  final doctorDirectory = <Map<String, dynamic>>[
    {
      'id': 'DOC001',
      'name': 'Dr. Priya Sharma',
      'specialization': 'General Medicine',
      'area': 'North Zone',
      'isActive': true,
      'availabilitySlots': {
        'Monday': [
          {'label': '09:00 AM - 10:00 AM', 'status': 'Free'},
          {'label': '06:00 PM - 07:00 PM', 'status': 'Booked'},
        ],
      },
    },
    {
      'id': 'DOC002',
      'name': 'Dr. Amit Patel',
      'specialization': 'Cardiology',
      'area': 'Central Zone',
      'isActive': true,
      'availabilitySlots': {
        'Tuesday': [
          {'label': '10:00 AM - 11:00 AM', 'status': 'Free'},
        ],
      },
    },
    {
      'id': 'DOC003',
      'name': 'Dr. Nisha Verma',
      'specialization': 'Dermatology',
      'area': 'South Zone',
      'isActive': false,
      'availabilitySlots': {
        'Wednesday': [
          {'label': '04:00 PM - 05:00 PM', 'status': 'Booked'},
        ],
      },
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _seedData();
  }

  void _seedData() {
    if (prescriptions.isEmpty) {
      prescriptions.assignAll([
        Prescription(
          id: 'RX-1001',
          doctorId: 'DOC001',
          doctorName: 'Dr. Priya Sharma',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          drugEntries: const [
            DrugEntry(
              drugName: 'Amlodipine',
              dosage: '5mg',
              durationDays: 30,
              morning: true,
              afternoon: false,
              night: true,
              instructions: 'After food',
            ),
            DrugEntry(
              drugName: 'Telmisartan',
              dosage: '40mg',
              durationDays: 30,
              morning: true,
              afternoon: false,
              night: false,
              instructions: 'Before breakfast',
            ),
          ],
          remarks: 'Monitor BP daily for 2 weeks.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          expiryDate: DateTime.now().add(const Duration(days: 27)),
        ),
      ]);
    }

    if (followUps.isEmpty) {
      followUps.assignAll([
        FollowUpRecord(
          id: 'FU-3001',
          prescriptionId: 'RX-1001',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          doctorId: 'DOC001',
          doctorName: 'Dr. Priya Sharma',
          notes: 'Blood pressure improved. Mild dizziness in the evening.',
          updatedMedication: 'Reduce Amlodipine to 2.5mg at night if dizziness persists.',
          nextVisitDate: DateTime.now().add(const Duration(days: 10)),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);
    }

    if (referrals.isEmpty) {
      referrals.assignAll([
        DoctorReferral(
          id: 'REF-5001',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          referredDoctorId: 'DOC002',
          referredDoctorName: 'Dr. Amit Patel',
          referringDoctorId: 'DOC001',
          referringDoctorName: 'Dr. Priya Sharma',
          reason: 'Cardiac Workup',
          description: 'Patient has intermittent chest discomfort. Need cardiology opinion.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'Pending',
        ),
      ]);
    }

    if (appointments.isEmpty) {
      appointments.assignAll([
        Appointment(
          id: 'CONS001',
          doctorId: 'DOC001',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          mode: 'Virtual',
          appointmentDate: DateTime.now().add(const Duration(days: 1)),
          timeSlot: '09:00 AM - 10:00 AM',
          status: 'Waiting',
          reason: 'Persistent headache and mild fever for 3 days',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Appointment(
          id: 'CONS002',
          doctorId: 'DOC003',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          mode: 'Home Service',
          appointmentDate: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '04:00 PM - 05:00 PM',
          status: 'Waiting',
          reason: 'Skin allergy with redness and itching',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Appointment(
          id: 'CONS003',
          doctorId: 'DOC002',
          patientId: 'P1',
          patientName: 'Rajesh Kumar',
          mode: 'Virtual',
          appointmentDate: DateTime.now().subtract(const Duration(days: 2)),
          timeSlot: '10:00 AM - 11:00 AM',
          status: 'Completed',
          reason: 'Follow-up for blood pressure review',
          notes: 'Consultation completed',
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
        ),
      ]);
    }
  }

  List<Appointment> getAppointmentsForDoctor(String doctorId) {
    return appointments.where((item) => item.doctorId == doctorId).toList();
  }

  List<Appointment> getAppointmentsForPatient(String patientId) {
    return appointments.where((item) => item.patientId == patientId).toList();
  }

  void addAppointment(Appointment appointment) {
    appointments.insert(0, appointment);
  }

  Appointment? getAppointmentById(String appointmentId) {
    return appointments.firstWhereOrNull((item) => item.id == appointmentId);
  }

  void updateAppointmentStatus({
    required String appointmentId,
    required String status,
    String? notes,
  }) {
    final index = appointments.indexWhere((item) => item.id == appointmentId);
    if (index < 0) {
      return;
    }

    final current = appointments[index];
    appointments[index] = Appointment(
      id: current.id,
      doctorId: current.doctorId,
      patientId: current.patientId,
      patientName: current.patientName,
      mode: current.mode,
      appointmentDate: current.appointmentDate,
      timeSlot: current.timeSlot,
      status: status,
      reason: current.reason,
      notes: notes ?? current.notes,
      createdAt: current.createdAt,
    );
  }

  void updateAppointmentTimeSlot({
    required String appointmentId,
    required String newTimeSlot,
    String? notes,
  }) {
    final index = appointments.indexWhere((item) => item.id == appointmentId);
    if (index < 0) {
      return;
    }

    final current = appointments[index];
    appointments[index] = Appointment(
      id: current.id,
      doctorId: current.doctorId,
      patientId: current.patientId,
      patientName: current.patientName,
      mode: current.mode,
      appointmentDate: current.appointmentDate,
      timeSlot: newTimeSlot,
      status: current.status,
      reason: current.reason,
      notes: notes ?? current.notes,
      createdAt: current.createdAt,
    );
  }

  void removeAppointment(String appointmentId) {
    appointments.removeWhere((item) => item.id == appointmentId);
    rescheduleRequests.remove(appointmentId);
  }

  List<String> getFreeDoctorSlotsForDay({
    required String doctorId,
    required String day,
  }) {
    final doctorIndex = doctorDirectory.indexWhere((item) => item['id'] == doctorId);
    if (doctorIndex < 0) {
      return const [];
    }

    final doctor = Map<String, dynamic>.from(doctorDirectory[doctorIndex]);
    final rawWeekly = Map<String, dynamic>.from(
      doctor['availabilitySlots'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );
    final daySlots = List<Map<String, dynamic>>.from(
      (rawWeekly[day] as List? ?? const []),
    );

    return daySlots
        .where((slot) => (slot['status'] ?? 'Free') == 'Free')
        .map((slot) => (slot['label'] ?? '').toString())
        .where((slot) => slot.isNotEmpty)
        .toList();
  }

  bool requestRescheduleSlot({
    required String appointmentId,
    required String requestedSlot,
  }) {
    final appointment = getAppointmentById(appointmentId);
    if (appointment == null) {
      return false;
    }

    final day = _weekdayName(appointment.appointmentDate);
    final isFree = isDoctorSlotFree(
      doctorId: appointment.doctorId,
      day: day,
      slotLabel: requestedSlot,
    );
    if (!isFree) {
      return false;
    }

    rescheduleRequests[appointmentId] = {
      'appointmentId': appointmentId,
      'doctorId': appointment.doctorId,
      'patientId': appointment.patientId,
      'day': day,
      'requestedSlot': requestedSlot,
      'requestedAt': DateTime.now().toIso8601String(),
    };
    return true;
  }

  String? getRequestedRescheduleSlot(String appointmentId) {
    return rescheduleRequests[appointmentId]?['requestedSlot'] as String?;
  }

  void clearRescheduleRequest(String appointmentId) {
    rescheduleRequests.remove(appointmentId);
  }

  String _weekdayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  bool isDoctorSlotFree({
    required String doctorId,
    required String day,
    required String slotLabel,
  }) {
    final doctorIndex = doctorDirectory.indexWhere((item) => item['id'] == doctorId);
    if (doctorIndex < 0) {
      return false;
    }

    final doctor = Map<String, dynamic>.from(doctorDirectory[doctorIndex]);
    final rawWeekly = Map<String, dynamic>.from(
      doctor['availabilitySlots'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

    final daySlots = List<Map<String, dynamic>>.from(
      (rawWeekly[day] as List? ?? const []),
    );

    final slot = daySlots.firstWhereOrNull((item) => item['label'] == slotLabel);
    if (slot == null) {
      return false;
    }

    return (slot['status'] ?? 'Free') == 'Free';
  }

  void setDoctorSlotStatus({
    required String doctorId,
    required String day,
    required String slotLabel,
    required String status,
  }) {
    final doctorIndex = doctorDirectory.indexWhere((item) => item['id'] == doctorId);
    if (doctorIndex < 0) {
      return;
    }

    final doctor = Map<String, dynamic>.from(doctorDirectory[doctorIndex]);
    final rawWeekly = Map<String, dynamic>.from(
      doctor['availabilitySlots'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

    final daySlots = List<Map<String, dynamic>>.from(
      (rawWeekly[day] as List? ?? const []),
    );

    final slotIndex = daySlots.indexWhere((item) => item['label'] == slotLabel);
    if (slotIndex < 0) {
      daySlots.add({'label': slotLabel, 'status': status});
    } else {
      daySlots[slotIndex] = {
        ...daySlots[slotIndex],
        'status': status,
      };
    }

    rawWeekly[day] = daySlots;
    doctor['availabilitySlots'] = rawWeekly;
    doctorDirectory[doctorIndex] = doctor;
  }

  void upsertDoctorDirectory(Map<String, dynamic> doctor) {
    final index = doctorDirectory.indexWhere((item) => item['id'] == doctor['id']);
    if (index >= 0) {
      doctorDirectory[index] = doctor;
    } else {
      doctorDirectory.insert(0, doctor);
    }
  }

  void addPrescription(Prescription prescription) {
    prescriptions.insert(0, prescription);
  }

  void addFollowUp(FollowUpRecord followUp) {
    followUps.insert(0, followUp);
  }

  void addReferral(DoctorReferral referral) {
    referrals.insert(0, referral);
  }

  bool updateReferralStatus({
    required String referralId,
    required String status,
    String? patientId,
  }) {
    final index = referrals.indexWhere((item) => item.id == referralId);
    if (index < 0) {
      return false;
    }

    final current = referrals[index];
    if (patientId != null && patientId.isNotEmpty && current.patientId != patientId) {
      return false;
    }

    referrals[index] = current.copyWith(status: status);
    return true;
  }
}
