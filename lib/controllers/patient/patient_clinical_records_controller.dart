import 'package:get/get.dart';

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
  }

  void acceptReferral(String referralId) {
    final isUpdated = _clinicalDataService.updateReferralStatus(
      referralId: referralId,
      status: 'Accepted',
      patientId: _currentPatientId,
    );
    if (!isUpdated) {
      Get.snackbar('Invalid Referral', 'Referral ID is not valid for this patient.');
      return;
    }
    loadRecords();
    Get.snackbar('Referral Accepted', 'Referral accepted by ID: $referralId');
  }

  void ignoreReferral(String referralId) {
    final isUpdated = _clinicalDataService.updateReferralStatus(
      referralId: referralId,
      status: 'Ignored',
      patientId: _currentPatientId,
    );
    if (!isUpdated) {
      Get.snackbar('Invalid Referral', 'Referral ID is not valid for this patient.');
      return;
    }
    loadRecords();
    Get.snackbar('Referral Ignored', 'Referral ignored by ID: $referralId');
  }
}
