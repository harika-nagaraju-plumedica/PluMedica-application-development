import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hospital/hospital_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/hospital/consultation_step_header_widget.dart';

class HospitalConsultationSearchView
    extends GetView<HospitalConsultationController> {
  const HospitalConsultationSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Global Search + Serach Bar',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const ConsultationStepHeaderWidget(currentStep: 2),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Global searchbar',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  TextFormField(
                    controller: controller.globalSearchController,
                    decoration: InputDecoration(
                      hintText:
                          'Search patient, consultant, admission or payment',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.createNewConsultation,
                      icon: const Icon(Icons.add),
                      label: const Text('New Consultation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation Focus',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Obx(
                    () => Wrap(
                      spacing: AppConstants.paddingSmall,
                      runSpacing: AppConstants.paddingSmall,
                      children: controller.focusAreas
                          .map(
                            (item) => ChoiceChip(
                              label: Text(item),
                              selected:
                                  controller.selectedFocusArea.value == item,
                              onSelected: (_) => controller.setFocusArea(item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Serach Bar',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField('Name', controller.searchNameController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField('Age', controller.searchAgeController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField('Gender', controller.searchGenderController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField('Address', controller.searchAddressController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'History of consultation',
                    controller.searchHistoryController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Labs ordered',
                    controller.searchLabsOrderedController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Date of Admission',
                    controller.searchDateOfAdmissionController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Date of Discharge',
                    controller.searchDateOfDischargeController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.openIntakeScreen,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.openAdmissionDetailsScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarkBlue,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.labelMedium.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      border: Border.all(color: AppColors.veryLightGrey),
    );
  }
}
