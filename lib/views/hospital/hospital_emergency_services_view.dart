import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_emergency_services_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/hospital/emergency_alert_widget.dart';

class HospitalEmergencyServicesView
    extends GetView<HospitalEmergencyServicesController> {
  const HospitalEmergencyServicesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Emergency Services',
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
                    Container(
                      padding: const EdgeInsets.all(
                          AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: AppColors.error,
                          ),
                          const SizedBox(
                              width: AppConstants.paddingMedium),
                          Expanded(
                            child: Text(
                              'Active Emergency Alerts: ${controller.emergencyAlerts.length}',
                              style: AppFonts.labelLarge.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    Text(
                      'Pending Alerts',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.emergencyAlerts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 64,
                                  color: AppColors.success,
                                ),
                                const SizedBox(
                                    height:
                                        AppConstants.paddingMedium),
                                Text(
                                  'No emergency alerts',
                                  style: AppFonts.bodyMedium
                                      .copyWith(
                                    color:
                                        AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: controller.emergencyAlerts
                                .map(
                                  (alert) =>
                                      EmergencyAlertWidgetItem(
                                        patientName:
                                            'Patient Name',
                                        bedNumber: 'A-05',
                                        description:
                                            'Sudden heart rate drop',
                                        severity: 'Critical',
                                        alertTime: DateTime.now(),
                                        onAcknowledge:
                                            () => controller
                                                .acknowledgeAlert(
                                                    alert),
                                        onRespond: () =>
                                            controller
                                                .respondToEmergency(
                                                    alert),
                                      ),
                                )
                                .toList(),
                          ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    if (controller.respondedAlerts
                        .isNotEmpty) ...[
                      Text(
                        'Responded Alerts',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(
                          height: AppConstants.paddingMedium),
                      Container(
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Responded: ${controller.respondedAlerts.length}',
                              style: AppFonts.bodyMedium
                                  .copyWith(
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    AppConstants.paddingMedium),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: controller
                                    .clearRespondedAlerts,
                                style:
                                    OutlinedButton.styleFrom(
                                  foregroundColor:
                                      AppColors.success,
                                ),
                                child:
                                    const Text('Clear Alerts'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

