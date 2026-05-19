import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_dashboard_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/hospital/hospital_header_widget.dart';
import '../../widgets/hospital/hospital_summary_card_widget.dart';

class HospitalDashboardView extends GetView<HospitalDashboardController> {
  const HospitalDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshDashboard,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 08),
                      HospitalHeaderWidget(
                        hospitalName: controller.hospitalName.value,
                        hospitalLogo: 'assets/images/logo.jpeg',
                        generatedId: controller.hospitalGeneratedId.value,
                        status: controller.hospitalStatus.value,
                        onSettingsTap: () {
                          // TODO: Navigate to settings
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppConstants.paddingMedium,
                        mainAxisSpacing: AppConstants.paddingMedium,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          HospitalSummaryCardWidget(
                            title: 'Total Patients',
                            value: controller.totalPatients.toString(),
                            icon: Icons.people,
                            backgroundColor: AppColors.primaryBlue.withValues(
                              alpha: 0.1,
                            ),
                            textColor: AppColors.primaryBlue,
                            onTap: () {
                              // TODO: Navigate to patient list
                            },
                          ),
                          HospitalSummaryCardWidget(
                            title: 'Occupied Beds',
                            value:
                                '${controller.occupiedBeds}/${controller.totalBeds}',
                            icon: Icons.bed,
                            backgroundColor: AppColors.warning.withValues(
                              alpha: 0.1,
                            ),
                            textColor: AppColors.warning,
                            onTap: () {
                              // TODO: Navigate to bed management
                            },
                          ),
                          HospitalSummaryCardWidget(
                            title: 'Active Consultants',
                            value: controller.activeConsultants.toString(),
                            icon: Icons.person_outline,
                            backgroundColor: AppColors.green.withValues(
                              alpha: 0.1,
                            ),
                            textColor: AppColors.green,
                            onTap: controller.navigateToConsultantManagement,
                          ),
                          HospitalSummaryCardWidget(
                            title: 'Emergency Alerts',
                            value: controller.emergencyAlerts.toString(),
                            icon: Icons.emergency,
                            backgroundColor: AppColors.error.withValues(
                              alpha: 0.1,
                            ),
                            textColor: AppColors.error,
                            onTap: controller.navigateToEmergencyServices,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      Text(
                        'Quick Access',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: controller.navigateToConsultation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.veryLightGrey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.medical_information_outlined,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(
                                    width: AppConstants.paddingMedium,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Consultation',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          GestureDetector(
                            onTap: controller.navigateToConsultantManagement,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.veryLightGrey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(
                                    width: AppConstants.paddingMedium,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Consultant Management',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          GestureDetector(
                            onTap: controller.navigateToAdmissionManagement,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.veryLightGrey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.hotel, color: AppColors.warning),
                                  const SizedBox(
                                    width: AppConstants.paddingMedium,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Admission Management',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          GestureDetector(
                            onTap: () => Get.toNamed('/diagnostics/dashboard'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.veryLightGrey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.biotech,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(
                                    width: AppConstants.paddingMedium,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Diagnostics Bulk Requests',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
