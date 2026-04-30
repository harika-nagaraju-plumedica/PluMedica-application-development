import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/diagnostics/diagnostics_dashboard_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class DiagnosticsTopHeader extends StatelessWidget {
  final DiagnosticsDashboardController controller;
  final bool isDesktop;

  const DiagnosticsTopHeader({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedMenu.value;
      final canNavigateBack =
          selectedIndex != 0 || Navigator.of(context).canPop();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.veryLightGrey)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (!isDesktop)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canNavigateBack)
                        IconButton(
                          tooltip: 'Back',
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            if (selectedIndex != 0) {
                              controller.setMenu(0);
                              return;
                            }

                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).maybePop();
                              return;
                            }

                            Get.offAllNamed('/role_selection');
                          },
                        ),
                      Builder(
                        builder: (innerContext) => IconButton(
                          tooltip: 'Open navigation menu',
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            final scaffold = Scaffold.maybeOf(innerContext);
                            scaffold?.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Text(
                    DiagnosticsDashboardController.menus[selectedIndex],
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified,
                        color: AppColors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Live',
                        style: AppFonts.labelSmall.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout),
                  onPressed: controller.logout,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.globalSearchController,
              decoration: InputDecoration(
                hintText: 'Global search by Patient ID / Name / Mobile',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.globalSearchController.clear();
                    controller.notifyUi();
                  },
                ),
              ),
              onChanged: (_) => controller.notifyUi(),
            ),
          ],
        ),
      );
    });
  }
}
