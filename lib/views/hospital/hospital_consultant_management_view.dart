import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_consultant_management_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/hospital/consultant_list_tile_widget.dart';

class HospitalConsultantManagementView
    extends GetView<HospitalConsultantManagementController> {
  const HospitalConsultantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Consultant Management',
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
                      'Available Consultants',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.availableConsultants.isEmpty
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
                                'No available consultants',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.availableConsultants
                                .map(
                                  (consultant) =>
                                      ConsultantListTileWidget(
                                        consultantName: 'Dr. Consultant',
                                        specialization:
                                            'Cardiologist',
                                        qualification: 'MBBS, MD',
                                        availability:
                                            'Mon - Fri',
                                        isAvailable: true,
                                        onTap: () => controller
                                            .viewConsultantDetails(
                                                consultant),
                                      ),
                                )
                                .toList(),
                          ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    Text(
                      'Busy Consultants',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.busyConsultants.isEmpty
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
                                'No busy consultants',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.busyConsultants
                                .map(
                                  (consultant) =>
                                      ConsultantListTileWidget(
                                        consultantName: 'Dr. Busy',
                                        specialization:
                                            'General Physician',
                                        qualification: 'MBBS',
                                        availability:
                                            'On consultation',
                                        isAvailable: false,
                                        onTap: () => controller
                                            .viewConsultantDetails(
                                                consultant),
                                      ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addConsultant,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
