import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient/patient_clinical_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class PatientReferralsView extends GetView<PatientClinicalRecordsController> {
  const PatientReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Assigned Doctors & Notifications'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            Text('Patient Notifications', style: AppFonts.labelLarge),
            const SizedBox(height: 8),
            if (controller.patientNotifications.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No new notifications.'),
                ),
              )
            else
              ...controller.patientNotifications.map(
                (notification) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: Text(notification['message']?.toString() ?? '-'),
                    subtitle: Text(
                      'Status: ${notification['status'] ?? 'Pending'}',
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Assigned Doctors', style: AppFonts.labelLarge),
            const SizedBox(height: 8),
            ...controller.referrals.map((referral) {
              final statusColor = controller.statusColor(referral.status);
              final date = referral.requestedDate?.toString().split(' ').first ?? '-';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            referral.referredDoctorName,
                            style: AppFonts.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            referral.status,
                            style: AppFonts.labelSmall.copyWith(
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Specialization: ${referral.doctorSpecialization ?? '-'}',
                      style: AppFonts.bodySmall,
                    ),
                    Text('Appointment: $date, ${referral.requestedTimeSlot ?? '-'}'),
                    Text('Visit Type: ${referral.visitType}'),
                    if ((referral.hospitalOrClinic ?? '').isNotEmpty)
                      Text('Hospital/Clinic: ${referral.hospitalOrClinic}'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                controller.viewReferralDetails(referral),
                            child: const Text('View Details'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: referral.status == 'Accepted'
                                ? () => controller.requestReschedule(referral.id)
                                : null,
                            child: const Text('Reschedule'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
