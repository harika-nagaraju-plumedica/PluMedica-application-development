import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Pending Verification View - Shows after registration submission
/// Displayed until super admin approves the registration
class PendingVerificationView extends StatefulWidget {
  final String registrationType; // e.g., "Pharmacy", "Doctor", "Hospital"
  final String userEmail; // User's registered email
  final VoidCallback? onLoginPressed;

  const PendingVerificationView({
    Key? key,
    required this.registrationType,
    this.userEmail = '',
    this.onLoginPressed,
  }) : super(key: key);

  @override
  State<PendingVerificationView> createState() =>
      _PendingVerificationViewState();
}

class _PendingVerificationViewState extends State<PendingVerificationView> {
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 5;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _secondsRemaining--;
        });
        if (_secondsRemaining > 0) {
          _startTimer();
        } else {
          // Navigate to appropriate login screen after 5 seconds
          _navigateToNextScreen();
        }
      }
    });
  }

  void _navigateToNextScreen() {
    switch (widget.registrationType) {
      case 'Pharmacy':
        Get.offNamed('/pharmacy/login');
        break;
      case 'Doctor':
        Get.offNamed('/doctor_login');
        break;
      case 'Hospital':
        Get.offNamed('/hospital/login');
        break;
      case 'Patient':
        Get.offNamed('/patient/login');
        break;
      default:
        Get.offNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Pending Icon with animation effect
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 80,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Main Heading
                  Text(
                    'Registration Submitted!',
                    style: AppFonts.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subheading
                  Text(
                    'Your ${widget.registrationType} registration is under review',
                    style: AppFonts.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                      border: Border.all(
                        color: AppColors.warning,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pending Verification',
                          style: AppFonts.labelLarge.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Information Box
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.05),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What happens next?',
                          style: AppFonts.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoPoint(
                          '1. Our admin team will review your registration details',
                        ),
                        _buildInfoPoint(
                          '2. We will verify your documents and information',
                        ),
                        _buildInfoPoint(
                          '3. You will receive an email once your registration is approved',
                        ),
                        _buildInfoPoint(
                          '4. After approval, you can log in and start using Plumedica',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email notification info
                  if (widget.userEmail.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: AppColors.success,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Notification Email',
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userEmail,
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ll send a confirmation email to this address',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 48),

                  // Expected timeline
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.veryLightGrey,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expected Timeline',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '24 - 48 hours',
                          style: AppFonts.heading3.copyWith(
                            color: AppColors.primaryDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Verification usually completed within 1-2 business days',
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Auto-redirect countdown timer
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.autorenew,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Auto-Redirect in Progress',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Redirecting to login page in $_secondsRemaining second${_secondsRemaining == 1 ? '' : 's'}...',
                          style: AppFonts.labelLarge.copyWith(
                            color: AppColors.primaryDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Countdown progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _secondsRemaining / 5,
                            minHeight: 6,
                            backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Contact Support
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: AppColors.primaryBlue,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Need Help?',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you have any questions, contact our support team at support@plumedica.com',
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _navigateToNextScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusMedium,
                          ),
                        ),
                      ),
                      child: Text(
                        'Continue to Login',
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement logout logic
                        Get.offNamed('/');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusMedium,
                          ),
                        ),
                      ),
                      child: Text(
                        'Return to Home',
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
