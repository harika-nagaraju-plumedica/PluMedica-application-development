import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hospital/hospital_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class HospitalConsultationView extends GetView<HospitalConsultationController> {
  const HospitalConsultationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Hospital Consultation',
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
                    _buildPromptHeader(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildHospitalDashboardBlock(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    _buildFlowScreensBlock(),
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPromptHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _SketchPromptTile(
            label: 'What you want to know ?',
            onTap: controller.openSearchScreen,
          ),
          SizedBox(height: AppConstants.paddingSmall),
          _SketchPromptTile(
            label: 'What you want to do ?',
            onTap: controller.openIntakeScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalDashboardBlock() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hospital Dashboard',
            style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'ID No',
            style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppConstants.paddingSmall,
            mainAxisSpacing: AppConstants.paddingSmall,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            children: [
              _DashboardActionButton(
                label: 'Consultations',
                icon: Icons.medical_information_outlined,
                onTap: controller.openIntakeScreen,
              ),
              _DashboardActionButton(
                label: 'Payment History',
                icon: Icons.payment,
                onTap: () =>
                    controller.navigateToModule('/hospital/payment_summary'),
              ),
              _DashboardActionButton(
                label: 'Patient details',
                icon: Icons.badge_outlined,
                onTap: () =>
                    controller.navigateToModule('/hospital/patient_records'),
              ),
              _DashboardActionButton(
                label: 'Consultants',
                icon: Icons.group_outlined,
                onTap: () => controller.navigateToModule(
                  '/hospital/consultant_management',
                ),
              ),
              _DashboardActionButton(
                label: 'Emergency services',
                icon: Icons.emergency_outlined,
                onTap: () =>
                    controller.navigateToModule('/hospital/emergency_services'),
              ),
              _DashboardActionButton(
                label: 'Admissions',
                icon: Icons.local_hotel_outlined,
                onTap: () => controller.navigateToModule(
                  '/hospital/admission_management',
                ),
              ),
              _DashboardActionButton(
                label: 'Job posting',
                icon: Icons.work_outline,
                onTap: () =>
                    controller.navigateToModule('/hospital/job_postings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowScreensBlock() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Flow Screens',
            style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Open each screen to fill exact fields from the shared sketch.',
            style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _FlowScreenTile(
            title: 'Screen 1: Intake',
            subtitle:
                'Job Posting, Schedule consultation timing ?, Patient Admission ?',
            onTap: () => Get.toNamed('/hospital/consultation/intake'),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          _FlowScreenTile(
            title: 'Screen 2: Global Search + Serach Bar',
            subtitle:
                'Global searchbar, New Consultation, focus chips and search details',
            onTap: () => Get.toNamed('/hospital/consultation/search'),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          _FlowScreenTile(
            title: 'Screen 3: Admission Details',
            subtitle:
                'Date of Admission, Date of Discharge, Consultations, Consultants, Admitted under',
            onTap: () =>
                Get.toNamed('/hospital/consultation/admission_details'),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          _FlowScreenTile(
            title: 'Screen 4: Consultation Form',
            subtitle:
                'Urgent Guid, Specialisation, Reason for consultation, Description',
            onTap: () => Get.toNamed('/hospital/consultation/form'),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      border: Border.all(color: AppColors.veryLightGrey),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _SketchPromptTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SketchPromptTile({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _DashboardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.primaryDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowScreenTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FlowScreenTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
