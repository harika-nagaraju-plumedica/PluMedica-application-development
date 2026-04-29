import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient/patient_health_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class PatientHealthRecordsView extends GetView<PatientHealthRecordsController> {
  const PatientHealthRecordsView({super.key});

  static const _actionView = 'view';
  static const _actionDownload = 'download';
  static const _actionShare = 'share';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Health Records',
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
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusLarge),
                        border: Border.all(color: AppColors.lightBlue),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: AppColors.lightBlue),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Text(
                              'All your medical documents are stored securely',
                              style: AppFonts.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Recent Records',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.healthRecords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.document_scanner,
                                  size: 64,
                                  color: AppColors.lightGrey,
                                ),
                                const SizedBox(
                                  height: AppConstants.paddingMedium,
                                ),
                                Text(
                                  'No records found',
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
                            itemCount: controller.healthRecords.length,
                            itemBuilder: (context, index) {
                              final record = controller.healthRecords[index];
                              final recordId = (record['id'] ?? '').toString();

                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: AppConstants.paddingMedium,
                                ),
                                padding: const EdgeInsets.all(
                                  AppConstants.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border:
                                      Border.all(color: AppColors.veryLightGrey),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusLarge,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.borderRadiusMedium,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf,
                                        color: AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppConstants.paddingMedium,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (record['title'] ?? 'Medical Record')
                                                .toString(),
                                            style: AppFonts.labelLarge.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            (record['date'] ?? '').toString(),
                                            style: AppFonts.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (action) {
                                        if (action == _actionView) {
                                          controller.viewRecord(recordId);
                                        } else if (action == _actionDownload) {
                                          controller.downloadRecord(recordId);
                                        } else if (action == _actionShare) {
                                          controller.shareRecord(recordId);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem<String>(
                                          value: _actionView,
                                          child: Text('View'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: _actionDownload,
                                          child: Text('Download'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: _actionShare,
                                          child: Text('Share'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.uploadRecord,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
