import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../views/role_selection_view.dart';

/// Navigation controller for GetX routing
class NavigationController extends GetxController {
  /// Observable variable to track current screen
  final Rx<int> currentScreen = 0.obs;

  /// Navigate to role selection screen2
  void goToRoleSelection() {
    currentScreen.value = 0;
    Get.offAll(
      () => const RoleSelectionView(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('NavigationController initialized');
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (kDebugMode) {
      print('NavigationController disposed');
    }
  }
}
