import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_dashboard_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/patient_header_widget.dart';
import '../../widgets/patient/quick_action_tile_widget.dart';
import '../../widgets/patient/health_metric_card_widget.dart';

class PatientDashboardView extends GetView<PatientDashboardController> {
  const PatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: PatientHeaderWidget(
                          patientName: controller.patientName.value,
                          profileImage: controller.profileImage.value,
                          onProfileTap: () {
                            Get.toNamed('/patient/profile');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: controller.navigateToSOS,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.emergency,
                                    color: AppColors.white,
                                    size: 30,
                                  ),
                                  Text(
                                    'SOS',
                                    style: AppFonts.labelMedium.copyWith(
                                      color: AppColors.white,
                                      fontWeight: AppFonts.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppConstants.paddingMedium,
                          mainAxisSpacing: AppConstants.paddingMedium,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            QuickActionTileWidget(
                              label: 'Medical History',
                              icon: Icons.history,
                              backgroundColor: AppColors.primaryBlue,
                              onTap: controller.navigateToMedicalHistory,
                            ),
                            QuickActionTileWidget(
                              label: 'Health Records',
                              icon: Icons.document_scanner,
                              backgroundColor: AppColors.green,
                              onTap: controller.navigateToHealthRecords,
                            ),
                            QuickActionTileWidget(
                              label: 'Fitness',
                              icon: Icons.fitness_center,
                              backgroundColor: AppColors.warning,
                              onTap: controller.navigateToFitness,
                            ),
                            QuickActionTileWidget(
                              label: 'Book Doctor',
                              icon: Icons.person_add,
                              backgroundColor: AppColors.purple,
                              onTap: controller.navigateToConsultation,
                            ),
                            QuickActionTileWidget(
                              label: 'Referral Doctors',
                              icon: Icons.forward_to_inbox,
                              backgroundColor: AppColors.lightBlue,
                              onTap: controller.navigateToReferrals,
                            ),
                            QuickActionTileWidget(
                              label: 'Diagnostics',
                              icon: Icons.biotech,
                              backgroundColor: AppColors.primaryDarkBlue,
                              onTap: () =>
                                  Get.toNamed('/diagnostics/dashboard'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Health Metrics',
                              style: AppFonts.heading3.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppConstants.paddingMedium,
                              mainAxisSpacing: AppConstants.paddingMedium,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                HealthMetricCardWidget(
                                  label: 'BP',
                                  value: '120',
                                  unit: 'mmHg',
                                  icon: Icons.favorite,
                                  backgroundColor: AppColors.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  iconColor: AppColors.error,
                                ),
                                HealthMetricCardWidget(
                                  label: 'HR',
                                  value: '75',
                                  unit: 'bpm',
                                  icon: Icons.favorite,
                                  backgroundColor: AppColors.warning.withValues(
                                    alpha: 0.1,
                                  ),
                                  iconColor: AppColors.warning,
                                ),
                                HealthMetricCardWidget(
                                  label: 'Weight',
                                  value: '72',
                                  unit: 'kg',
                                  icon: Icons.fitness_center,
                                  backgroundColor: AppColors.green.withValues(
                                    alpha: 0.1,
                                  ),
                                  iconColor: AppColors.green,
                                ),
                                HealthMetricCardWidget(
                                  label: 'Oxygen',
                                  value: '98',
                                  unit: '%',
                                  icon: Icons.air,
                                  backgroundColor: AppColors.lightBlue
                                      .withValues(alpha: 0.1),
                                  iconColor: AppColors.lightBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
