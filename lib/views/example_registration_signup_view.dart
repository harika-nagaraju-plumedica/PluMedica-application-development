import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patient/patient_registration_controller.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class ExampleRegistrationSignupView extends StatelessWidget {
  const ExampleRegistrationSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientRegistrationController());

    return Scaffold(
      appBar: AppBar(title: const Text('Signup Example')),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextField(
                label: 'Full Name',
                hint: 'John Doe',
                onChanged: (v) => controller.fullName.value = v,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Email',
                hint: 'john@example.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => controller.email.value = v,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Mobile',
                hint: '9876543210',
                keyboardType: TextInputType.phone,
                onChanged: (v) => controller.mobileNumber.value = v,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Password',
                hint: '********',
                obscureText: true,
                onChanged: (v) => controller.password.value = v,
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Create Account',
                isLoading: controller.isLoading.value,
                onPressed: controller.register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
