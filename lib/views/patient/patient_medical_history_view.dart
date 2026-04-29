import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_medical_history_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/medical_history_tile_widget.dart';

class PatientMedicalHistoryView
    extends GetView<PatientMedicalHistoryController> {
  const PatientMedicalHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Medical History',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Appointments', 'Medications', 'Tests']
                              .map(
                                (category) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: FilterChip(
                                    label: Text(category),
                                    selected:
                                        controller.selectedCategory.value ==
                                            category,
                                    onSelected: (_) =>
                                        controller.filterByCategory(category),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: controller.medicalHistory.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color: AppColors.lightGrey,
                                  ),
                                  const SizedBox(height: AppConstants.paddingMedium),
                                  Text(
                                    'No medical history found',
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: controller.medicalHistory
                                  .map(
                                    (item) =>
                                        MedicalHistoryTileWidget(
                                          title: item['title'] as String,
                                          description: item['description'] as String,
                                          date: item['date'] as String,
                                          doctorName: item['doctorName'] as String?,
                                          icon: _categoryIcon(
                                            item['category'] as String,
                                          ),
                                          onTap: () =>
                                              controller.viewDetails(item['id'] as String),
                                        ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Appointments':
        return Icons.event_note;
      case 'Medications':
        return Icons.medication;
      case 'Tests':
        return Icons.biotech;
      default:
        return Icons.history;
    }
  }
}
