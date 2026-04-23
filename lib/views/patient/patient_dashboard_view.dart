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
  const PatientDashboardView({Key? key}) : super(key: key);

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
            onPressed: () {
              Get.offNamed('/patient/login');
            },
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
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        child: PatientHeaderWidget(
                          patientName: controller.patientName.value,
                          profileImage: controller.profileImage.value,
                          onProfileTap: () {
                            Get.toNamed('/patient/profile');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
                              onTap: () => Get.toNamed('/patient/health-records'),
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
                                  backgroundColor: AppColors.error.withOpacity(0.1),
                                  iconColor: AppColors.error,
                                ),
                                HealthMetricCardWidget(
                                  label: 'HR',
                                  value: '75',
                                  unit: 'bpm',
                                  icon: Icons.favorite,
                                  backgroundColor: AppColors.warning.withOpacity(0.1),
                                  iconColor: AppColors.warning,
                                ),
                                HealthMetricCardWidget(
                                  label: 'Weight',
                                  value: '72',
                                  unit: 'kg',
                                  icon: Icons.fitness_center,
                                  backgroundColor: AppColors.green.withOpacity(0.1),
                                  iconColor: AppColors.green,
                                ),
                                HealthMetricCardWidget(
                                  label: 'Oxygen',
                                  value: '98',
                                  unit: '%',
                                  icon: Icons.air,
                                  backgroundColor: AppColors.lightBlue.withOpacity(0.1),
                                  iconColor: AppColors.lightBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        child: GestureDetector(
                          onTap: controller.navigateToSOS,
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.paddingMedium),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              border: Border.all(color: AppColors.error),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.borderRadiusLarge),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emergency,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: AppConstants.paddingMedium),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Emergency Alert',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.error,
                                      ),
                                    ),
                                    Text(
                                      'Tap to activate S.O.S',
                                      style: AppFonts.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios,
                                    color: AppColors.error),
                              ],
                            ),
                          ),
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
