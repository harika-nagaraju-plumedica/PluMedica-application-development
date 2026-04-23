import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';
import '../controllers/registration_controller.dart';
import '../widgets/auth_button.dart';

/// Registration type selection view
class RegisterAsView extends StatelessWidget {
  const RegisterAsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register As',
                style: AppFonts.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Expanded(
                child: GetBuilder<RegistrationController>(
                  builder: (controller) => ListView.builder(
                    itemCount: controller.registrationTypes.length,
                    itemBuilder: (context, index) {
                      final type = controller.registrationTypes[index];
                      final isSelected = controller.isTypeSelected(type);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingSmall,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              controller.selectRegistrationType(type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingMedium,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.lightPurple.withOpacity(0.2)
                                  : AppColors.veryLightGrey,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.purple
                                    : AppColors.lightGrey,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type,
                                  style: AppFonts.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: isSelected
                                        ? AppFonts.semiBold
                                        : AppFonts.regular,
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        AppColors.lightGrey,
                                  ),
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => controller
                                        .selectRegistrationType(type),
                                    activeColor: AppColors.purple,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              GetBuilder<RegistrationController>(
                builder: (controller) => AuthButton(
                  text: 'Submit',
                  onPressed: controller.selectedRegistrationType.value != null
                      ? () => controller.submitRegistration()
                      : null,
                  isEnabled: controller.selectedRegistrationType.value != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
