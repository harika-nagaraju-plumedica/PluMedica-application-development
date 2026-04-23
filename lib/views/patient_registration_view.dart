import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plumedica_application_development/utils/extensions.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/auth_button.dart';
import '../widgets/app_text_field.dart';

/// Patient registration form view
class PatientRegistrationView extends StatefulWidget {
  const PatientRegistrationView({Key? key}) : super(key: key);

  @override
  State<PatientRegistrationView> createState() =>
      _PatientRegistrationViewState();
}

class _PatientRegistrationViewState extends State<PatientRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _mailIdController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _mailIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Patient registration submitted',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration Form'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.verticalBlueGradient,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AppTextField(
                  label: 'Age',
                  hint: 'Enter your age',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Age is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AppTextField(
                  label: 'Gender',
                  hint: 'Enter gender (Male/Female/Other)',
                  controller: _genderController,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Gender is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AppTextField(
                  label: 'Address',
                  hint: 'Enter your address',
                  controller: _addressController,
                  maxLines: 2,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AppTextField(
                  label: 'Mail ID',
                  hint: 'Enter email address',
                  controller: _mailIdController,
                  keyboardType: TextInputType.emailAddress,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Email is required';
                    }
                    if (!value!.isValidEmail) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AppTextField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  required: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Phone number is required';
                    }
                    if (!value!.isValidPhone) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.verticalBlueGradient,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusLarge,
                    ),
                  ),
                  child: AuthButton(
                    text: 'Register',
                    onPressed: _submitForm,
                    isPrimary: false,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
