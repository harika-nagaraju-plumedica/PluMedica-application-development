import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
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
                              label: 'Pending',
                              value:
                                  controller.pendingAppointments.length.toString(),
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
                              label: 'Earnings',
                              value:
                                  '₹${controller.totalEarnings.value.toStringAsFixed(0)}',
                              icon: Icons.attach_money,
                              backgroundColor: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pending Appointments Section
                      SectionHeader(
                        title: 'Pending Appointments',
                      ),
                      const SizedBox(height: 12),
                      if (controller.pendingAppointments.isEmpty)
                        const EmptyStateWidget(
                          message: 'No pending appointments',
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
                      SectionHeader(
                        title: 'Quick Actions',
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
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
}
