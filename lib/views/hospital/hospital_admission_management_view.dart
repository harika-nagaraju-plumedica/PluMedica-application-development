import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_admission_management_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/hospital/admission_status_widget.dart';

class HospitalAdmissionManagementView
    extends GetView<HospitalAdmissionManagementController> {
  const HospitalAdmissionManagementView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Admission Management',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Admissions',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.activeAdmissions.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingLarge),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Center(
                              child: Text(
                                'No active admissions',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.activeAdmissions
                                .map(
                                  (admission) =>
                                      AdmissionStatusWidgetItem(
                                        patientName:
                                            'John Doe',
                                        wardNumber: 'A-01',
                                        bedNumber: '05',
                                        admissionDate:
                                            'Jan 10, 2026',
                                        status: 'Stable',
                                        onTap: () => controller
                                            .viewAdmissionDetails(
                                                admission),
                                      ),
                                )
                                .toList(),
                          ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    Text(
                      'Recently Discharged',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.dischargedPatients.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingLarge),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Center(
                              child: Text(
                                'No discharged patients',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.dischargedPatients
                                .map(
                                  (patient) =>
                                      AdmissionStatusWidgetItem(
                                        patientName:
                                            'Jane Smith',
                                        wardNumber: 'B-02',
                                        bedNumber: '12',
                                        admissionDate:
                                            'Jan 01, 2026',
                                        status: 'Discharged',
                                        onTap: () {},
                                      ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addAdmission,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
