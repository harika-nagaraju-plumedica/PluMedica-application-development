import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/doctor_referral_notifications_controller.dart';
import '../models/referral_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

class DoctorReferralNotificationsView
    extends GetView<DoctorReferralNotificationsController> {
  const DoctorReferralNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Incoming Referrals'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(() {
        if (controller.incomingReferrals.isEmpty) {
          return const Center(
            child: Text('No incoming referrals.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: controller.incomingReferrals.length,
          itemBuilder: (context, index) {
            final referral = controller.incomingReferrals[index];
            return _ReferralNotificationCard(
              referral: referral,
              onAccept: () => controller.acceptReferral(referral),
              onReject: () => controller.rejectReferral(referral),
              onSuggest: () => _openSuggestTimeDialog(context, referral),
              statusColor: controller.statusColor(referral.status),
            );
          },
        );
      }),
    );
  }

  void _openSuggestTimeDialog(BuildContext context, DoctorReferral referral) {
    controller.suggestionController.text = referral.suggestedTimeSlot ?? '';
    Get.dialog(
      AlertDialog(
        title: const Text('Suggest Different Time'),
        content: TextField(
          controller: controller.suggestionController,
          decoration: const InputDecoration(
            labelText: 'Suggested Time Slot',
            hintText: 'Example: 04:00 PM - 05:00 PM',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => controller.suggestDifferentTime(referral),
            child: const Text('Send Suggestion'),
          ),
        ],
      ),
    );
  }
}

class _ReferralNotificationCard extends StatelessWidget {
  final DoctorReferral referral;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onSuggest;
  final Color statusColor;

  const _ReferralNotificationCard({
    required this.referral,
    required this.onAccept,
    required this.onReject,
    required this.onSuggest,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final requestedDate =
        referral.requestedDate?.toString().split(' ').first ?? '-';
    final requestedSlot = referral.requestedTimeSlot ?? '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${referral.patientName} (${referral.patientId})',
                    style: AppFonts.labelLarge,
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
                    style: AppFonts.labelSmall.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Specialization: ${referral.doctorSpecialization ?? '-'}',
              style: AppFonts.bodySmall,
            ),
            Text('Visit Type: ${referral.visitType}', style: AppFonts.bodySmall),
            Text(
              'Requested Slot: $requestedDate, $requestedSlot',
              style: AppFonts.bodySmall,
            ),
            Text(
              'From: ${referral.referringDoctorName}',
              style: AppFonts.bodySmall,
            ),
            if ((referral.suggestedTimeSlot ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Suggested by doctor: ${referral.suggestedTimeSlot}',
                  style: AppFonts.bodySmall.copyWith(color: AppColors.primaryBlue),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: referral.status == 'Pending' ? onReject : null,
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: referral.status == 'Pending' ? onSuggest : null,
                    child: const Text('Suggest Time'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: referral.status == 'Pending' ? onAccept : null,
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
