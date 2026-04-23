import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/consultation_card_widget.dart';

class PatientConsultationView
    extends GetView<PatientConsultationController> {
  const PatientConsultationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Doctor Consultations',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshConsultations,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      controller.upcomingConsultations.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(
                                  AppConstants.paddingLarge),
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusLarge),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 48,
                                    color: AppColors.lightGrey,
                                  ),
                                  const SizedBox(
                                      height: AppConstants.paddingMedium),
                                  Text(
                                    'No upcoming consultations',
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: controller
                                  .upcomingConsultations
                                  .map(
                                    (consultation) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  AppConstants.paddingMedium),
                                          child:
                                              ConsultationCardWidget(
                                            doctorName:
                                                'Dr. Smith',
                                            specialization:
                                                'Cardiologist',
                                            dateTime:
                                                'Jan 20, 2026 - 2:00 PM',
                                            status: 'Upcoming',
                                            onVideoCall:
                                                () =>
                                                    controller
                                                        .startVideoCall(
                                                            consultation),
                                            onChat: () =>
                                                controller.openChat(
                                                    consultation),
                                            onReschedule:
                                                () =>
                                                    controller.reschedule(
                                                        consultation),
                                          ),
                                        ),
                                  )
                                  .toList(),
                            ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      Text(
                        'Completed',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      controller.completedConsultations.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(
                                  AppConstants.paddingLarge),
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusLarge),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 48,
                                    color: AppColors.lightGrey,
                                  ),
                                  const SizedBox(
                                      height: AppConstants.paddingMedium),
                                  Text(
                                    'No completed consultations',
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: controller
                                  .completedConsultations
                                  .map(
                                    (consultation) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  AppConstants.paddingMedium),
                                          child:
                                              ConsultationCardWidget(
                                            doctorName:
                                                'Dr. John',
                                            specialization:
                                                'General Physician',
                                            dateTime:
                                                'Jan 15, 2026 - 10:00 AM',
                                            status: 'Completed',
                                            onVideoCall:
                                                () {},
                                            onChat: () =>
                                                controller.openChat(
                                                    consultation),
                                            onReschedule:
                                                () {},
                                          ),
                                        ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.bookDoctor,
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
