import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSending = false;

  late final String _moduleName;
  late final String _loginRoute;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?)?.cast<String, dynamic>() ?? {};
    _moduleName = (args['moduleName'] as String?) ?? 'Account';
    _loginRoute = (args['loginRoute'] as String?) ?? '/role_selection';
    _emailController.text = (args['registeredEmail'] as String?) ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Registered email is required';
    }
    const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    if (!RegExp(pattern).hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    setState(() => _isSending = false);

    final email = _emailController.text.trim();
    Get.snackbar(
      'Reset Link Sent',
      'A password reset link has been sent to $email',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.toNamed(
      '/auth/reset-password',
      arguments: {
        'moduleName': _moduleName,
        'loginRoute': _loginRoute,
        'registeredEmail': email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('$_moduleName Forgot Password'),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset your password',
                style: AppFonts.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email to receive a reset link.',
                style: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              AppTextField(
                label: 'Registered Email',
                hint: 'Enter registered email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                required: true,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              AppButton(
                text: 'Send Reset Link',
                onPressed: _sendResetLink,
                isLoading: _isSending,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Get.offNamed(_loginRoute),
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isResetting = false;
  late final String _moduleName;
  late final String _loginRoute;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?)?.cast<String, dynamic>() ?? {};
    _moduleName = (args['moduleName'] as String?) ?? 'Account';
    _loginRoute = (args['loginRoute'] as String?) ?? '/role_selection';
    _emailController.text = (args['registeredEmail'] as String?) ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    final otp = value?.trim() ?? '';
    if (otp.isEmpty) {
      return 'Reset code is required';
    }
    if (otp.length < 4) {
      return 'Enter a valid reset code';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isResetting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    setState(() => _isResetting = false);

    Get.snackbar(
      'Password Updated',
      'Your $_moduleName password has been reset successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.offAllNamed(_loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('$_moduleName Reset Password'),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new password',
                style: AppFonts.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Use the reset code sent to your registered email.',
                style: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              AppTextField(
                label: 'Registered Email',
                hint: 'Registered email',
                controller: _emailController,
                readOnly: true,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              AppTextField(
                label: 'Reset Code',
                hint: 'Enter reset code',
                controller: _otpController,
                required: true,
                validator: _validateOtp,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              AppTextField(
                label: 'New Password',
                hint: 'Enter new password',
                controller: _newPasswordController,
                obscureText: true,
                required: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              AppTextField(
                label: 'Confirm Password',
                hint: 'Re-enter new password',
                controller: _confirmPasswordController,
                obscureText: true,
                required: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              AppButton(
                text: 'Reset Password',
                onPressed: _resetPassword,
                isLoading: _isResetting,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
