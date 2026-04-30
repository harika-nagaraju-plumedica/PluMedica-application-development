import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/follow_up_model.dart';
import '../../models/prescription_model.dart';
import '../../models/referral_model.dart';
import '../../services/admin_identity_service.dart';
import '../../services/clinical_data_service.dart';
import '../../services/patient_session_service.dart';

class PatientClinicalRecordsController extends GetxController {
  final _clinicalDataService = Get.put(ClinicalDataService(), permanent: true);
  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
      ? Get.find<AdminIdentityService>()
      : Get.put(AdminIdentityService(), permanent: true);

  String get _currentPatientId =>
      _adminIdentityService.getPrimaryId(AppRole.patient);

  final prescriptions = <Prescription>[].obs;
  final followUps = <FollowUpRecord>[].obs;
  final referrals = <DoctorReferral>[].obs;
  final patientNotifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  void loadRecords() {
    prescriptions.assignAll(_clinicalDataService.prescriptions);
    followUps.assignAll(_clinicalDataService.followUps);
    referrals.assignAll(
      _clinicalDataService.referrals
          .where((item) => item.patientId == _currentPatientId)
          .toList(),
    );
    patientNotifications.assignAll(
      _clinicalDataService.getPatientNotifications(_currentPatientId),
    );
  }

  void viewReferralDetails(DoctorReferral referral) {
    final date = referral.requestedDate?.toString().split(' ').first ?? '-';
    Get.dialog(
      AlertDialog(
        title: const Text('Referral Details'),
        content: Text(
          'Assigned Doctor: ${referral.referredDoctorName}\n'
          'Specialization: ${referral.doctorSpecialization ?? '-'}\n'
          'Date: $date\n'
          'Time: ${referral.requestedTimeSlot ?? '-'}\n'
          'Visit Type: ${referral.visitType}\n'
          'Hospital/Clinic: ${referral.hospitalOrClinic ?? '-'}\n'
          'Status: ${referral.status}',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void requestReschedule(String referralId) {
    final isUpdated = _clinicalDataService.updateReferralStatus(
      referralId: referralId,
      status: 'Pending',
      patientId: _currentPatientId,
    );
    if (!isUpdated) {
      Get.snackbar('Invalid Referral', 'Referral ID is not valid for this patient.');
      return;
    }
    patientNotifications.insert(0, {
      'id': 'PRN-${DateTime.now().millisecondsSinceEpoch}',
      'patientId': _currentPatientId,
      'referralId': referralId,
      'status': 'Pending',
      'message': 'Reschedule requested for referral $referralId.',
      'createdAt': DateTime.now().toIso8601String(),
    });
    loadRecords();
    Get.snackbar('Reschedule Requested', 'Doctor will respond with a new time.');
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
