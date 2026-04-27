import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_fitness_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/fitness_stat_widget.dart';

class PatientFitnessView extends GetView<PatientFitnessController> {
  const PatientFitnessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Fitness & Health',
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
                      'Today\'s Activity',
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
                        GestureDetector(
                          onTap: () => controller.viewStats('BMI'),
                          child: FitnessStatWidget(
                            label: 'BMI',
                            value:
                                controller.bmi.value.toStringAsFixed(1),
                            additionalInfo: 'Normal Weight',
                            statusColor: AppColors.green,
                            icon: Icons.monitor_weight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.viewStats('Steps'),
                          child: FitnessStatWidget(
                            label: 'Steps',
                            value:
                                '${controller.steps.value}',
                            additionalInfo: 'Target: 10000',
                            statusColor: AppColors.warning,
                            icon: Icons.directions_walk,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.viewStats('Calories'),
                          child: FitnessStatWidget(
                            label: 'Calories',
                            value:
                                controller.caloriesBurned.value
                                    .toStringAsFixed(0),
                            additionalInfo: 'Burned',
                            statusColor: AppColors.error,
                            icon: Icons.local_fire_department,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.viewStats('Water'),
                          child: FitnessStatWidget(
                            label: 'Water',
                            value:
                                '${controller.waterIntake.value}',
                            additionalInfo: 'Cups / 8 target',
                            statusColor: AppColors.lightBlue,
                            icon: Icons.water_drop,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: AppColors.greenGoldenGradient,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tonight\'s Sleep',
                                    style: AppFonts.labelMedium.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${controller.sleepHours.value} hrs',
                                    style: AppFonts.heading2.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.nights_stay,
                                color: AppColors.white,
                                size: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Recent Logs',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.fitnessLogs.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 64,
                                  color: AppColors.lightGrey,
                                ),
                                const SizedBox(
                                    height: AppConstants.paddingMedium),
                                Text(
                                  'No logs yet',
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addFitnessLog,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
