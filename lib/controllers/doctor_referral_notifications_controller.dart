import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/referral_model.dart';
import '../services/admin_identity_service.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';

class DoctorReferralNotificationsController extends GetxController {
  final _clinicalDataService = Get.isRegistered<ClinicalDataService>()
      ? Get.find<ClinicalDataService>()
      : Get.put(ClinicalDataService(), permanent: true);

  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
      ? Get.find<AdminIdentityService>()
      : Get.put(AdminIdentityService(), permanent: true);

  final incomingReferrals = <DoctorReferral>[].obs;
  final suggestionController = TextEditingController();

  String get currentDoctorId =>
      _adminIdentityService.getPrimaryId(AppRole.doctor);

  @override
  void onInit() {
    super.onInit();
    loadIncomingReferrals();
    _clinicalDataService.markDoctorNotificationsRead(currentDoctorId);
  }

  void loadIncomingReferrals() {
    incomingReferrals.assignAll(
      _clinicalDataService.getIncomingReferralsForDoctor(currentDoctorId),
    );
  }

  void acceptReferral(DoctorReferral referral) {
    final ok = _clinicalDataService.respondToReferral(
      referralId: referral.id,
      doctorId: currentDoctorId,
      action: 'accept',
    );
    if (!ok) {
      Get.snackbar('Error', 'Unable to accept referral.');
      return;
    }
    loadIncomingReferrals();
    Get.snackbar('Accepted', 'Referral accepted and appointment confirmed.');
  }

  void rejectReferral(DoctorReferral referral) {
    final ok = _clinicalDataService.respondToReferral(
      referralId: referral.id,
      doctorId: currentDoctorId,
      action: 'reject',
    );
    if (!ok) {
      Get.snackbar('Error', 'Unable to reject referral.');
      return;
    }
    loadIncomingReferrals();
    Get.snackbar('Rejected', 'Referral rejected and requester notified.');
  }

  void suggestDifferentTime(DoctorReferral referral) {
    final suggestion = suggestionController.text.trim();
    if (suggestion.isEmpty) {
      Get.snackbar('Validation Error', 'Enter a suggested time slot.');
      return;
    }
    final ok = _clinicalDataService.respondToReferral(
      referralId: referral.id,
      doctorId: currentDoctorId,
      action: 'suggest',
      suggestedTimeSlot: suggestion,
    );
    if (!ok) {
      Get.snackbar('Error', 'Unable to suggest time.');
      return;
    }
    suggestionController.clear();
    loadIncomingReferrals();
    Get.back();
    Get.snackbar('Suggested', 'Alternative slot sent to patient/requester.');
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

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }
}
