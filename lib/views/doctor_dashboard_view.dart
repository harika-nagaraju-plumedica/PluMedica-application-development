import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/index.dart';

/// Doctor Dashboard View
class DoctorDashboardView extends GetView<DoctorDashboardController> {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: 'Doctor Dashboard',
        onLogout: controller.logout,
        actions: [
          Obx(
            () {
              final count = controller.incomingReferralCount.value;
              return IconButton(
                tooltip: 'Incoming Referrals',
                onPressed: controller.openIncomingReferrals,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count > 9 ? '9+' : '$count',
                            style: AppFonts.labelSmall.copyWith(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingStateWidget()
            : RefreshIndicator(
                onRefresh: controller.refreshDashboard,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Profile Card
                      if (controller.doctor.value != null)
                        DoctorProfileCard(doctor: controller.doctor.value!),
                      const SizedBox(height: 24),

                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Patients',
                              value: controller.totalPatients.toString(),
                              icon: Icons.people,
                              backgroundColor: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Waiting',
                              value: controller.pendingAppointments.length
                                  .toString(),
                              icon: Icons.schedule,
                              backgroundColor: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Completed',
                              value: controller.completedAppointments.length
                                  .toString(),
                              icon: Icons.check_circle,
                              backgroundColor: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Fee Received',
                              value:
                                  '₹${controller.totalEarnings.value.toStringAsFixed(0)}',
                              icon: Icons.attach_money,
                              backgroundColor: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Waiting Appointments Section
                      SectionHeader(title: 'Waiting Appointments'),
                      const SizedBox(height: 12),
                      if (controller.pendingAppointments.isEmpty)
                        const EmptyStateWidget(
                          message: 'No waiting appointments',
                          icon: Icons.calendar_today,
                        )
                      else
                        Column(
                          children: controller.pendingAppointments
                              .take(3)
                              .map(
                                (appointment) => AppointmentCard(
                                  appointment: appointment,
                                  onTap: () {},
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 24),

                      // Quick Actions
                      SectionHeader(title: 'Doctor Actions Panel'),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: [
                          _doctorActionCard(
                            label: 'Prescription',
                            icon: Icons.medication,
                            color: AppColors.primaryBlue,
                            onTap: controller.openPrescription,
                          ),
                          _doctorActionCard(
                            label: 'Order Labs',
                            icon: Icons.science,
                            color: AppColors.warning,
                            onTap: controller.openOrderLabs,
                          ),
                          _doctorActionCard(
                            label: 'Schedule Follow-up',
                            icon: Icons.event_repeat,
                            color: AppColors.success,
                            onTap: controller.openScheduleFollowUp,
                          ),
                          _doctorActionCard(
                            label: 'Referrals',
                            icon: Icons.forward_to_inbox_outlined,
                            color: AppColors.primaryDarkBlue,
                            onTap: controller.openReferrals,
                            isPrimary: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SectionHeader(title: 'Other Actions'),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          AppButton(
                            text: 'Doctor Workflow Guide',
                            onPressed: controller.viewWorkflowGuide,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.warning,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'View All Appointments',
                            onPressed: controller.viewAppointments,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.primaryBlue,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Patient History',
                            onPressed: controller.viewPatientHistory,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.primaryBlue,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Manage Prescriptions',
                            onPressed: controller.viewPrescriptions,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.primaryBlue,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'View Payments',
                            onPressed: controller.viewPayments,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.success,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Incoming Referrals',
                            onPressed: controller.openIncomingReferrals,
                            width: double.infinity,
                            height: 45,
                            backgroundColor: AppColors.primaryDarkBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _doctorActionCard({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPrimary ? color.withValues(alpha: 0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: color.withValues(alpha: isPrimary ? 0.9 : 0.35),
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: isPrimary ? 0.24 : 0.16),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppFonts.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isPrimary)
                    Text(
                      'PRIMARY FLOW',
                      style: AppFonts.labelSmall.copyWith(
                        color: color,
                        fontWeight: AppFonts.semiBold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
