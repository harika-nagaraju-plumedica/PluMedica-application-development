import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/jobs/jobs_controllers.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class JobSeekerRegistrationView
    extends GetView<JobSeekerRegistrationController> {
  const JobSeekerRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Job Seeker Registration',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Profile',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Obx(
                      () => AppTextField(
                        label: 'Full Name',
                        hint: 'Enter name',
                        initialValue: controller.fullName.value,
                        onChanged: (val) => controller.fullName.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppTextField(
                        label: 'Email',
                        hint: 'Enter email',
                        keyboardType: TextInputType.emailAddress,
                        initialValue: controller.email.value,
                        onChanged: (val) => controller.email.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppTextField(
                        label: 'Phone',
                        hint: 'Enter phone',
                        keyboardType: TextInputType.phone,
                        initialValue: controller.phone.value,
                        onChanged: (val) => controller.phone.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppTextField(
                        label: 'Experience',
                        hint: 'Enter experience',
                        initialValue: controller.experience.value,
                        onChanged: (val) => controller.experience.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Register',
                      onPressed: controller.register,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class JobSeekerLoginView extends GetView<JobSeekerLoginController> {
  const JobSeekerLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(
                          AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                      ),
                      child: Center(
                        child: Text(
                          'Job Portal',
                          style: AppFonts.heading1.copyWith(
                            color: AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => AppTextField(
                        label: 'Email',
                        hint: 'Enter email',
                        keyboardType: TextInputType.emailAddress,
                        initialValue: controller.email.value,
                        onChanged: (val) => controller.email.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppTextField(
                        label: 'Password',
                        hint: 'Enter password',
                        obscureText: true,
                        initialValue: controller.password.value,
                        onChanged: (val) => controller.password.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Login',
                      onPressed: controller.login,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class JobSearchView extends GetView<JobSearchController> {
  const JobSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Find Jobs',
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
                  children: [
                    Obx(
                      () => AppTextField(
                        label: 'Search',
                        hint: 'Search jobs...',
                        prefixIcon: Icons.search,
                        onChanged: (val) =>
                            controller.searchQuery.value = val,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    controller.jobs.isEmpty
                        ? Center(
                            child: Text(
                              'No jobs found',
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: controller.jobs.length,
                            itemBuilder: (context, index) {
                              final job = controller.jobs[index];
                              return Container(
                                margin: const EdgeInsets.only(
                                    bottom: AppConstants
                                        .paddingMedium),
                                padding: const EdgeInsets.all(
                                    AppConstants.paddingMedium),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors
                                          .veryLightGrey),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants
                                          .borderRadiusLarge),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            job['title'] ?? 'N/A',
                                            style: AppFonts
                                                .labelLarge
                                                .copyWith(
                                              color: AppColors
                                                  .textPrimary,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .primaryBlue
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(4),
                                          ),
                                          child: Text(
                                            job['type'] ?? 'N/A',
                                            style: AppFonts
                                                .caption
                                                .copyWith(
                                              color: AppColors
                                                  .primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      job['company'] ?? 'N/A',
                                      style: AppFonts.bodySmall
                                          .copyWith(
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${job['location']} | ${job['salary']}',
                                      style: AppFonts.caption
                                          .copyWith(
                                        color: AppColors
                                            .textSecondary,
                                      ),
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
    );
  }
}

class JobListingView extends GetView<JobListingController> {
  const JobListingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Job Listings',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Apply Now',
                        onPressed: controller.applyForJob,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Applications',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.applications.isEmpty
                ? Center(
                    child: Text(
                      'No applications yet',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}

class EmployerRegistrationView
    extends GetView<EmployerRegistrationController> {
  const EmployerRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Employer Registration',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    AppTextField(
                        label: 'Company Name', hint: 'Enter name'),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(label: 'Email', hint: 'Enter email'),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Register',
                      onPressed: controller.register,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class EmployerLoginView extends GetView<EmployerLoginController> {
  const EmployerLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    AppTextField(label: 'Email', hint: 'Enter email'),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      obscureText: true,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Login',
                      onPressed: controller.login,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class JobPostingCreationView
    extends GetView<JobPostingCreationController> {
  const JobPostingCreationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Post Job',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    AppTextField(
                        label: 'Position Title',
                        hint: 'Enter position'),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(label: 'Salary', hint: 'Enter range'),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Post Job',
                      onPressed: controller.post,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CandidateListView extends GetView<CandidateListController> {
  const CandidateListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Candidates',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}

class CandidateDetailView extends GetView<CandidateDetailController> {
  const CandidateDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox.shrink(),
      ),
    );
  }
}
