import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_sos_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/sos_action_button_widget.dart';

class PatientSosView extends GetView<PatientSosController> {
  const PatientSosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Emergency SOS',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusLarge),
                  border: Border.all(color: AppColors.error),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppColors.error,
                      size: 40,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Emergency Alert System',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the button below to alert emergency services and your emergency contacts',
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingXLarge),
              Center(
                child: SosActionButtonWidget(
                  isActive: controller.isSOSActive.value,
                  onSosActivated: controller.activateSOS,
                  onCancel: controller.cancelSOS,
                ),
              ),
              const SizedBox(height: AppConstants.paddingXLarge),
              Text(
                'Emergency Contacts',
                style: AppFonts.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              controller.emergencyContacts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contacts,
                            size: 64,
                            color: AppColors.lightGrey,
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            'No emergency contacts added',
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.emergencyContacts.length,
                      itemBuilder: (context, index) {
                        final contact =
                            controller.emergencyContacts[index];
                        final contactId = contact['id'] ?? '';
                        final contactName = contact['name'] ?? 'Unnamed Contact';
                        final contactPhone = contact['phone'] ?? 'No phone number';
                        final contactRelation = contact['relation'] ?? '';
                        return Container(
                          padding: const EdgeInsets.all(
                              AppConstants.paddingMedium),
                          margin: const EdgeInsets.only(
                              bottom: AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border:
                                Border.all(color: AppColors.veryLightGrey),
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusLarge),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primaryBlue,
                                child: const Icon(Icons.person,
                                    color: AppColors.white),
                              ),
                              const SizedBox(
                                  width: AppConstants.paddingMedium),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contactName,
                                      style: AppFonts.labelLarge
                                          .copyWith(
                                        color:
                                            AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      contactRelation.isEmpty
                                          ? contactPhone
                                          : '$contactPhone  â€¢  $contactRelation',
                                      style: AppFonts.bodySmall
                                          .copyWith(
                                        color:
                                            AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.call),
                                color: AppColors.primaryDarkBlue,
                                onPressed: () => controller
                                    .callEmergencyContact(contactPhone),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: AppColors.primaryBlue,
                                onPressed: () => controller
                                    .editEmergencyContact(contactId),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: AppColors.error,
                                onPressed: () => controller
                                    .deleteEmergencyContact(contactId),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              const SizedBox(height: AppConstants.paddingMedium),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.addEmergencyContact,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Emergency Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

