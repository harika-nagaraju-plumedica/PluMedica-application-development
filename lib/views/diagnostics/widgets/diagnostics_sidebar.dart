import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/diagnostics/diagnostics_dashboard_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/fonts.dart';
import 'diagnostics_ui_components.dart';

class DiagnosticsSidebar extends StatelessWidget {
  final DiagnosticsDashboardController controller;

  const DiagnosticsSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedMenuIndex = controller.selectedMenu.value;

      return Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDarkBlue, AppColors.primaryBlue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.biotech,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.diagnosticsCenterName.value,
                            style: AppFonts.heading3.copyWith(
                              color: AppColors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Diagnostics Management System',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Navigation',
                style: AppFonts.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: DiagnosticsDashboardController.menus.length,
                itemBuilder: (context, index) {
                  final selected = selectedMenuIndex == index;
                  return ListTile(
                    leading: Icon(
                      _menuIcon(index),
                      color: selected
                          ? AppColors.primaryBlue
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      DiagnosticsDashboardController.menus[index],
                      style: AppFonts.bodyMedium.copyWith(
                        color: selected
                            ? AppColors.primaryDarkBlue
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? AppFonts.semiBold
                            : AppFonts.regular,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    selected: selected,
                    onTap: () {
                      controller.setMenu(index);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  DiagnosticsRoleTag(
                    label: 'Doctor',
                    color: AppColors.primaryBlue,
                  ),
                  DiagnosticsRoleTag(label: 'Patient', color: AppColors.green),
                  DiagnosticsRoleTag(
                    label: 'Pharmacy',
                    color: AppColors.warning,
                  ),
                  DiagnosticsRoleTag(
                    label: 'Hospital',
                    color: AppColors.primaryDarkBlue,
                  ),
                  DiagnosticsRoleTag(
                    label: 'Diagnostics',
                    color: AppColors.lightBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  IconData _menuIcon(int index) {
    return switch (index) {
      0 => Icons.dashboard,
      1 => Icons.list_alt,
      2 => Icons.person_search,
      3 => Icons.assignment_turned_in,
      4 => Icons.receipt_long,
      _ => Icons.analytics,
    };
  }
}
