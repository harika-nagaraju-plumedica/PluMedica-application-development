import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Select Your Role',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Text(
              'Choose how you want to use Plumedica',
              style: AppFonts.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXLarge),
            // Pharmacy Role
            _RoleCard(
              icon: Icons.local_pharmacy,
              title: 'Pharmacy',
              description: 'Register pharmacy, manage inventory & process orders',
              color: AppColors.green,
              onTap: () => Get.toNamed('/pharmacy/registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Doctor Role
            _RoleCard(
              icon: Icons.local_hospital,
              title: 'Doctor',
              description: 'Manage appointments, prescriptions & patient consultations',
              color: AppColors.primaryBlue,
              onTap: () => Get.toNamed('/doctor_registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Patient Role
            _RoleCard(
              icon: Icons.person_outline,
              title: 'Patient',
              description: 'Access health records, book consultations & manage medications',
              color: AppColors.lightBlue,
              onTap: () => Get.toNamed('/patient/registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Hospital Role
            _RoleCard(
              icon: Icons.local_hospital,
              title: 'Hospital',
              description: 'Manage admissions, consultants, emergencies & patient records',
              color: AppColors.gold,
              onTap: () => Get.toNamed('/hospital/registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Insurance Partner Role
            _RoleCard(
              icon: Icons.health_and_safety,
              title: 'Insurance Partner',
              description: 'Manage claims, policies, network hospitals & analytics',
              color: AppColors.purple,
              onTap: () => Get.toNamed('/partner/registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Job Seeker Role
            _RoleCard(
              icon: Icons.work_outline,
              title: 'Job Seeker',
              description: 'Search jobs, apply for positions & track applications',
              color: AppColors.primaryDarkBlue,
              onTap: () => Get.toNamed('/jobs/job-seeker/registration'),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Employer Role
            _RoleCard(
              icon: Icons.business_center,
              title: 'Employer',
              description: 'Post jobs, manage candidates & review applications',
              color: AppColors.lightPurple,
              onTap: () => Get.toNamed('/jobs/employer/registration'),
            ),
            const SizedBox(height: AppConstants.paddingXLarge),
            // Already have account button
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Already have an account? Login',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
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
                    description,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
