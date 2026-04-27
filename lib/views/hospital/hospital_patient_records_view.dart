import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_patient_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text_field.dart';

class HospitalPatientRecordsView
    extends GetView<HospitalPatientRecordsController> {
  const HospitalPatientRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Patient Records',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Search Patient',
                      hint: 'Search by name or patient ID',
                      prefixIcon: Icons.search,
                      onChanged: controller.search,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    controller.patientRecords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search,
                                  size: 64,
                                  color: AppColors.lightGrey,
                                ),
                                const SizedBox(
                                    height:
                                        AppConstants.paddingMedium),
                                Text(
                                  'No patient records found',
                                  style: AppFonts.bodyMedium
                                      .copyWith(
                                    color:
                                        AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                controller.patientRecords.length,
                            itemBuilder: (context, index) {
                              final record = controller
                                  .patientRecords[index];
                              return GestureDetector(
                                onTap: () => controller
                                    .viewPatientDetails(record),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom:
                                          AppConstants.paddingMedium),
                                  padding: const EdgeInsets
                                      .all(AppConstants
                                      .paddingMedium),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                        color: AppColors
                                            .veryLightGrey),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants
                                            .borderRadiusLarge),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors
                                                .primaryBlue,
                                        child: const Icon(
                                            Icons.person,
                                            color: AppColors
                                                .white),
                                      ),
                                      const SizedBox(
                                          width: AppConstants
                                              .paddingMedium),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              'Patient Name',
                                              style: AppFonts
                                                  .labelLarge
                                                  .copyWith(
                                                color: AppColors
                                                    .textPrimary,
                                              ),
                                            ),
                                            Text(
                                              'ID: P001',
                                              style: AppFonts
                                                  .bodySmall
                                                  .copyWith(
                                                color: AppColors
                                                    .textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons
                                            .arrow_forward_ios,
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
