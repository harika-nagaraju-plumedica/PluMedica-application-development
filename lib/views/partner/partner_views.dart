import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/partner/partner_controllers.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class PartnerRegistrationView extends GetView<PartnerRegistrationController> {
  const PartnerRegistrationView({Key? key}) : super(key: key);

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
          'Partner Registration',
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
                      'Register Your Organization',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppTextField(
                      label: 'Organization Name',
                      hint: 'Enter organization name',
                      initialValue: controller.companyName.value,
                      onChanged: (val) => controller.companyName.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter email',
                      keyboardType: TextInputType.emailAddress,
                      initialValue: controller.email.value,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Mobile',
                      hint: 'Enter mobile number',
                      keyboardType: TextInputType.phone,
                      initialValue: controller.phone.value,
                      onChanged: (val) => controller.phone.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'License Number',
                      hint: 'Enter license number',
                      initialValue: controller.licenseNumber.value,
                      onChanged: (val) => controller.licenseNumber.value = val,
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

class PartnerLoginView extends GetView<PartnerLoginController> {
  const PartnerLoginView({Key? key}) : super(key: key);

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
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                      ),
                      child: Center(
                        child: Text(
                          'Partner Portal',
                          style: AppFonts.heading1.copyWith(
                            color: AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Partner Login',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter email',
                      keyboardType: TextInputType.emailAddress,
                      initialValue: controller.email.value,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      obscureText: true,
                      initialValue: controller.password.value,
                      onChanged: (val) => controller.password.value = val,
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

class PartnerDashboardView extends GetView<PartnerDashboardController> {
  const PartnerDashboardView({Key? key}) : super(key: key);

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
            : RefreshIndicator(
                onRefresh: controller.refreshDashboard,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          gradient: AppColors.blueGradient,
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: AppFonts.bodyMedium
                                        .copyWith(
                                      color: AppColors.white
                                          .withOpacity(0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.partnerName.value,
                                    style: AppFonts.heading2
                                        .copyWith(
                                      color: AppColors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: AppConstants.paddingLarge),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing:
                            AppConstants.paddingMedium,
                        mainAxisSpacing:
                            AppConstants.paddingMedium,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.veryLightGrey),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            padding: const EdgeInsets.all(
                                AppConstants.paddingMedium),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people,
                                  color: AppColors.primaryBlue,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Members',
                                  style: AppFonts.bodySmall
                                      .copyWith(
                                    color:
                                        AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.totalMembers
                                      .toString(),
                                  style: AppFonts.heading2
                                      .copyWith(
                                    color:
                                        AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.veryLightGrey),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            padding: const EdgeInsets.all(
                                AppConstants.paddingMedium),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: AppColors.warning,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Active Claims',
                                  style: AppFonts.bodySmall
                                      .copyWith(
                                    color:
                                        AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.activeClaims
                                      .toString(),
                                  style: AppFonts.heading2
                                      .copyWith(
                                    color:
                                        AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: AppConstants.paddingLarge),
                      Text(
                        'Quick Access',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(
                          height: AppConstants.paddingMedium),
                      Column(
                        children: [
                          _buildQuickAccessButton(
                            icon: Icons.description,
                            title: 'Policies',
                            color: AppColors.primaryBlue,
                            onTap: controller.navigateToPolicies,
                          ),
                          const SizedBox(
                              height: AppConstants.paddingMedium),
                          _buildQuickAccessButton(
                            icon: Icons.assignment_turned_in,
                            title: 'Claims',
                            color: AppColors.warning,
                            onTap: controller.navigateToClaims,
                          ),
                          const SizedBox(
                              height: AppConstants.paddingMedium),
                          _buildQuickAccessButton(
                            icon: Icons.local_hospital,
                            title: 'Network',
                            color: AppColors.green,
                            onTap: controller.navigateToNetwork,
                          ),
                          const SizedBox(
                              height: AppConstants.paddingMedium),
                          _buildQuickAccessButton(
                            icon: Icons.bar_chart,
                            title: 'Reports',
                            color: AppColors.error,
                            onTap: controller.navigateToReports,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.veryLightGrey),
          borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusLarge),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Text(
                title,
                style: AppFonts.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 24,
              child: Icon(Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerPoliciesView extends GetView<PartnerPoliciesController> {
  const PartnerPoliciesView({Key? key}) : super(key: key);

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
          'Policies & Plans',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.policies.isEmpty
                ? Center(
                    child: Text(
                      'No policies found',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: controller.policies.length,
                    itemBuilder: (context, index) {
                      final policy = controller.policies[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.paddingMedium),
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                              color: AppColors.veryLightGrey),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    policy['name'] ?? 'N/A',
                                    style: AppFonts.labelLarge
                                        .copyWith(
                                      color: AppColors
                                          .textPrimary,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            4),
                                  ),
                                  child: Text(
                                    policy['status'] ?? 'N/A',
                                    style: AppFonts.caption
                                        .copyWith(
                                      color: AppColors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Members: ${policy['members']} | Coverage: ₹${policy['coverage']/100000}L',
                              style: AppFonts.bodySmall.copyWith(
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class PartnerClaimsView extends GetView<PartnerClaimsController> {
  const PartnerClaimsView({Key? key}) : super(key: key);

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
          'Claims & Subscriptions',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.claims.isEmpty
                ? Center(
                    child: Text(
                      'No claims found',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: controller.claims.length,
                    itemBuilder: (context, index) {
                      final claim = controller.claims[index];
                      final statusColor = claim['status'] ==
                              'Approved'
                          ? AppColors.green
                          : claim['status'] == 'Pending'
                              ? AppColors.warning
                              : AppColors.primaryBlue;
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.paddingMedium),
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                              color: AppColors.veryLightGrey),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    claim['claimant'] ?? 'N/A',
                                    style: AppFonts.labelLarge
                                        .copyWith(
                                      color: AppColors
                                          .textPrimary,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            4),
                                  ),
                                  child: Text(
                                    claim['status'] ?? 'N/A',
                                    style: AppFonts.caption
                                        .copyWith(
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amount: ₹${claim['amount']} | ${claim['hospital']}',
                              style: AppFonts.bodySmall.copyWith(
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class PartnerNetworkView extends GetView<PartnerNetworkController> {
  const PartnerNetworkView({Key? key}) : super(key: key);

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
          'Hospital Network',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.hospitals.isEmpty
                ? Center(
                    child: Text(
                      'No hospitals found',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: controller.hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = controller.hospitals[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.paddingMedium),
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                              color: AppColors.veryLightGrey),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    hospital['name'] ?? 'N/A',
                                    style: AppFonts.labelLarge
                                        .copyWith(
                                      color: AppColors
                                          .textPrimary,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 16,
                                        color: AppColors
                                            .warning),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${hospital['rating']}',
                                      style: AppFonts.caption
                                          .copyWith(
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${hospital['city']} | ${hospital['beds']} Beds | ${hospital['doctors']} Doctors',
                              style: AppFonts.bodySmall.copyWith(
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class PartnerReportsView extends GetView<PartnerReportsController> {
  const PartnerReportsView({Key? key}) : super(key: key);

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
          'Reports & Analytics',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.reports.isEmpty
                ? Center(
                    child: Text(
                      'No reports found',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: controller.reports.length,
                    itemBuilder: (context, index) {
                      final report = controller.reports[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.paddingMedium),
                        padding: const EdgeInsets.all(
                            AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                              color: AppColors.veryLightGrey),
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    report['title'] ?? 'N/A',
                                    style: AppFonts.labelLarge
                                        .copyWith(
                                      color: AppColors
                                          .textPrimary,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            4),
                                  ),
                                  child: Text(
                                    report['status'] ?? 'N/A',
                                    style: AppFonts.caption
                                        .copyWith(
                                      color: AppColors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${report['period']} | Generated: ${report['generatedDate']}',
                              style: AppFonts.bodySmall.copyWith(
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
