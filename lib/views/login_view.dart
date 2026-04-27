import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/auth_button.dart';
import 'register_as_view.dart';

/// Login view screen
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.white,
              AppColors.veryLightGrey,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo image
              Image.asset(
                'assets/images/logo.jpeg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              // App name
              Text(
                'Plumedica',
                style: AppFonts.heading1.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 64),
              // Login button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: AuthButton(
                  text: 'Login',
                  onPressed: () {
                    navigationController.goToRoleSelection();
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Register button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: AuthButton(
                  text: 'Register',
                  onPressed: () {
                    Get.to(() => const RegisterAsView());
                  },
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

