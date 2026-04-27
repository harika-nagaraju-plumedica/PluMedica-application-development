import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_job_postings_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class HospitalJobPostingsView
    extends GetView<HospitalJobPostingsController> {
  const HospitalJobPostingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Job Postings',
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
                    Text(
                      'Active Postings',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.activePostings.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingLarge),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Center(
                              child: Text(
                                'No active postings',
                                style: AppFonts.bodyMedium
                                    .copyWith(
                                  color:
                                      AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.activePostings
                                .map(
                                  (job) => GestureDetector(
                                    onTap: () => controller
                                        .viewJobDetails(job),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom:
                                              AppConstants
                                                  .paddingMedium),
                                      padding: const EdgeInsets
                                          .all(AppConstants
                                          .paddingMedium),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: AppColors
                                                .veryLightGrey),
                                        borderRadius: BorderRadius
                                            .circular(
                                          AppConstants
                                              .borderRadiusLarge,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                      'Senior Doctor',
                                                      style: AppFonts
                                                          .labelLarge
                                                          .copyWith(
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Cardiology',
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
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration:
                                                    BoxDecoration(
                                                  color: AppColors
                                                      .success
                                                      .withValues(alpha: 
                                                          0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppConstants
                                                            .borderRadiusSmall,
                                                      ),
                                                    ),
                                                child: Text(
                                                  'Active',
                                                  style: AppFonts
                                                      .caption
                                                      .copyWith(
                                                    color: AppColors
                                                        .success,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  AppConstants
                                                      .paddingMedium),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                '5 Applications',
                                                style: AppFonts
                                                    .bodySmall
                                                    .copyWith(
                                                  color: AppColors
                                                      .textSecondary,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    controller
                                                        .viewApplications(
                                                            job),
                                                child:
                                                    const Text(
                                                        'View'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createJobPosting,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

