import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/colors.dart';
import 'utils/fonts.dart';
import 'views/splash_view.dart';
import 'controllers/navigation_controller.dart';

// Doctor Flow Imports
import 'bindings/doctor_registration_binding.dart';
import 'bindings/doctor_login_binding.dart';
import 'bindings/doctor_dashboard_binding.dart';
import 'bindings/doctor_appointments_binding.dart';
import 'bindings/doctor_patient_history_binding.dart';
import 'bindings/doctor_prescriptions_binding.dart';
import 'bindings/doctor_payments_binding.dart';
import 'views/doctor_registration_view.dart';
import 'views/doctor_login_view.dart';
import 'views/doctor_dashboard_view.dart';
import 'views/doctor_appointments_view.dart';
import 'views/doctor_patient_history_view.dart';
import 'views/doctor_prescriptions_view.dart';
import 'views/doctor_payments_view.dart';

// Patient Flow Imports
import 'bindings/patient/patient_registration_binding.dart';
import 'bindings/patient/patient_login_binding.dart';
import 'bindings/patient/patient_dashboard_binding.dart';
import 'bindings/patient/patient_medical_history_binding.dart';
import 'bindings/patient/patient_fitness_binding.dart';
import 'bindings/patient/patient_health_records_binding.dart';
import 'bindings/patient/patient_consultation_binding.dart';
import 'bindings/patient/patient_pharmacy_binding.dart';
import 'bindings/patient/patient_sos_binding.dart';
import 'bindings/patient/patient_profile_binding.dart';
import 'views/patient/patient_registration_view.dart';
import 'views/patient/patient_login_view.dart';
import 'views/patient/patient_dashboard_view.dart';
import 'views/patient/patient_medical_history_view.dart';
import 'views/patient/patient_fitness_view.dart';
import 'views/patient/patient_health_records_view.dart';
import 'views/patient/patient_consultation_view.dart';
import 'views/patient/patient_pharmacy_view.dart';
import 'views/patient/patient_sos_view.dart';
import 'views/patient/patient_profile_view.dart';

// Hospital Flow Imports
import 'bindings/hospital/hospital_registration_binding.dart';
import 'bindings/hospital/hospital_login_binding.dart';
import 'bindings/hospital/hospital_dashboard_binding.dart';
import 'bindings/hospital/hospital_consultant_management_binding.dart';
import 'bindings/hospital/hospital_admission_management_binding.dart';
import 'bindings/hospital/hospital_emergency_services_binding.dart';
import 'bindings/hospital/hospital_patient_records_binding.dart';
import 'bindings/hospital/hospital_payment_summary_binding.dart';
import 'bindings/hospital/hospital_job_postings_binding.dart';
import 'views/hospital_registration_view.dart';

// Pharmacy Flow Imports
import 'bindings/pharmacy/pharmacy_registration_binding.dart';
import 'bindings/pharmacy/pharmacy_login_binding.dart';
import 'bindings/pharmacy/pharmacy_dashboard_binding.dart';
import 'bindings/pharmacy/pharmacy_orders_binding.dart';
import 'bindings/pharmacy/pharmacy_inventory_binding.dart';
import 'bindings/pharmacy/pharmacy_customers_binding.dart';
import 'bindings/pharmacy/pharmacy_sales_binding.dart';
import 'bindings/pharmacy/pharmacy_notifications_binding.dart';
import 'views/pharmacy_registration_view.dart';
import 'views/pharmacy_login_view.dart';
import 'views/pharmacy_dashboard_view.dart';
import 'views/pharmacy/pharmacy_orders_view.dart';
import 'views/pharmacy/pharmacy_inventory_view.dart';
import 'views/pharmacy/pharmacy_customers_view.dart';
import 'views/pharmacy/pharmacy_sales_view.dart';
import 'views/pharmacy/pharmacy_notifications_view.dart';
import 'views/pending_verification_view.dart';
import 'views/hospital/hospital_login_view.dart';
import 'views/hospital/hospital_dashboard_view.dart';
import 'views/hospital/hospital_consultant_management_view.dart';
import 'views/hospital/hospital_admission_management_view.dart';
import 'views/hospital/hospital_emergency_services_view.dart';
import 'views/hospital/hospital_patient_records_view.dart';
import 'views/hospital/hospital_payment_summary_view.dart';
import 'views/hospital/hospital_job_postings_view.dart';

// Partner Flow Imports
import 'bindings/partner/partner_bindings.dart';
import 'views/partner/partner_views.dart';

// Jobs Flow Imports
import 'bindings/jobs/jobs_bindings.dart';
import 'views/jobs/jobs_views.dart';

// Role Selection View
import 'views/role_selection_view.dart';

void main() {
  // Initialize GetX controllers before running the app
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plumedica',
      theme: _buildTheme(),
      home: const SplashView(),
      getPages: _buildPages(),
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const SplashView(),
        transition: Transition.fadeIn,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  List<GetPage> _buildPages() {
    return [
      // Role Selection Route
      GetPage(
        name: '/role_selection',
        page: () => const RoleSelectionView(),
        transition: Transition.fadeIn,
      ),

      // Pending Verification Route (shared across all registration types)
      GetPage(
        name: '/pending-verification',
        page: () {
          final arguments = Get.arguments ?? {};
          return PendingVerificationView(
            registrationType: arguments['registrationType'] ?? 'Registration',
            userEmail: arguments['userEmail'] ?? '',
          );
        },
        transition: Transition.fadeIn,
      ),
      
      // Doctor Flow Routes
      GetPage(
        name: '/doctor_registration',
        page: () => const DoctorRegistrationView(),
        binding: DoctorRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_login',
        page: () => const DoctorLoginView(),
        binding: DoctorLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_dashboard',
        page: () => const DoctorDashboardView(),
        binding: DoctorDashboardBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_appointments',
        page: () => const DoctorAppointmentsView(),
        binding: DoctorAppointmentsBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_patient_history',
        page: () => const DoctorPatientHistoryView(),
        binding: DoctorPatientHistoryBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_prescriptions',
        page: () => const DoctorPrescriptionsView(),
        binding: DoctorPrescriptionsBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/doctor_payments',
        page: () => const DoctorPaymentsView(),
        binding: DoctorPaymentsBinding(),
        transition: Transition.rightToLeft,
      ),

      // Patient Flow Routes
      GetPage(
        name: '/patient/registration',
        page: () => const PatientRegistrationView(),
        binding: PatientRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/login',
        page: () => const PatientLoginView(),
        binding: PatientLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/dashboard',
        page: () => const PatientDashboardView(),
        binding: PatientDashboardBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/medical_history',
        page: () => const PatientMedicalHistoryView(),
        binding: PatientMedicalHistoryBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/fitness',
        page: () => const PatientFitnessView(),
        binding: PatientFitnessBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/health_records',
        page: () => const PatientHealthRecordsView(),
        binding: PatientHealthRecordsBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/consultation',
        page: () => const PatientConsultationView(),
        binding: PatientConsultationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/pharmacy',
        page: () => const PatientPharmacyView(),
        binding: PatientPharmacyBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/sos',
        page: () => const PatientSosView(),
        binding: PatientSosBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/patient/profile',
        page: () => const PatientProfileView(),
        binding: PatientProfileBinding(),
        transition: Transition.rightToLeft,
      ),

      // Hospital Flow Routes
      GetPage(
        name: '/hospital/registration',
        page: () => const HospitalRegistrationView(),
        binding: HospitalRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/login',
        page: () => const HospitalLoginView(),
        binding: HospitalLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/dashboard',
        page: () => const HospitalDashboardView(),
        binding: HospitalDashboardBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/consultant_management',
        page: () => const HospitalConsultantManagementView(),
        binding: HospitalConsultantManagementBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/admission_management',
        page: () => const HospitalAdmissionManagementView(),
        binding: HospitalAdmissionManagementBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/emergency_services',
        page: () => const HospitalEmergencyServicesView(),
        binding: HospitalEmergencyServicesBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/patient_records',
        page: () => const HospitalPatientRecordsView(),
        binding: HospitalPatientRecordsBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/payment_summary',
        page: () => const HospitalPaymentSummaryView(),
        binding: HospitalPaymentSummaryBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/hospital/job_postings',
        page: () => const HospitalJobPostingsView(),
        binding: HospitalJobPostingsBinding(),
        transition: Transition.rightToLeft,
      ),

      // Pharmacy Flow Routes
      GetPage(
        name: '/pharmacy/registration',
        page: () => const PharmacyRegistrationView(),
        binding: PharmacyRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/login',
        page: () => const PharmacyLoginView(),
        binding: PharmacyLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/dashboard',
        page: () => const PharmacyDashboardView(),
        binding: PharmacyDashboardBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/orders',
        page: () => const PharmacyOrdersView(),
        binding: PharmacyOrdersBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/inventory',
        page: () => const PharmacyInventoryView(),
        binding: PharmacyInventoryBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/customers',
        page: () => const PharmacyCustomersView(),
        binding: PharmacyCustomersBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/sales',
        page: () => const PharmacySalesView(),
        binding: PharmacySalesBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/pharmacy/notifications',
        page: () => const PharmacyNotificationsView(),
        binding: PharmacyNotificationsBinding(),
        transition: Transition.rightToLeft,
      ),

      // Partner Flow Routes
      GetPage(
        name: '/partner/registration',
        page: () => const PartnerRegistrationView(),
        binding: PartnerRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/login',
        page: () => const PartnerLoginView(),
        binding: PartnerLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/dashboard',
        page: () => const PartnerDashboardView(),
        binding: PartnerDashboardBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/policies',
        page: () => const PartnerPoliciesView(),
        binding: PartnerPoliciesBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/claims',
        page: () => const PartnerClaimsView(),
        binding: PartnerClaimsBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/network',
        page: () => const PartnerNetworkView(),
        binding: PartnerNetworkBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/partner/reports',
        page: () => const PartnerReportsView(),
        binding: PartnerReportsBinding(),
        transition: Transition.rightToLeft,
      ),

      // Jobs Flow Routes - Job Seeker
      GetPage(
        name: '/jobs/job-seeker/registration',
        page: () => const JobSeekerRegistrationView(),
        binding: JobSeekerRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/job-seeker/login',
        page: () => const JobSeekerLoginView(),
        binding: JobSeekerLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/search',
        page: () => const JobSearchView(),
        binding: JobSearchBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/listing',
        page: () => const JobListingView(),
        binding: JobListingBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/detail',
        page: () => const JobDetailView(),
        binding: JobDetailBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/applications',
        page: () => const ApplicationStatusView(),
        binding: ApplicationStatusBinding(),
        transition: Transition.rightToLeft,
      ),

      // Jobs Flow Routes - Employer
      GetPage(
        name: '/jobs/employer/registration',
        page: () => const EmployerRegistrationView(),
        binding: EmployerRegistrationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/employer/login',
        page: () => const EmployerLoginView(),
        binding: EmployerLoginBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/employer/post-job',
        page: () => const JobPostingCreationView(),
        binding: JobPostingCreationBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/employer/candidates',
        page: () => const CandidateListView(),
        binding: CandidateListBinding(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/jobs/employer/candidate-detail',
        page: () => const CandidateDetailView(),
        binding: CandidateDetailBinding(),
        transition: Transition.rightToLeft,
      ),
    ];
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      hoverColor: AppColors.primaryBlue.withValues(alpha: 0.06),
      highlightColor: AppColors.primaryBlue.withValues(alpha: 0.08),
      splashColor: AppColors.primaryBlue.withValues(alpha: 0.10),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDarkBlue,
        primary: AppColors.primaryDarkBlue,
        secondary: AppColors.green,
        surface: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.heading3.copyWith(
          color: AppColors.white,
          fontWeight: AppFonts.bold,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: AppFonts.heading1.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppFonts.heading2.copyWith(color: AppColors.textPrimary),
        headlineSmall: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppFonts.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
        bodySmall: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
        labelLarge: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
        labelMedium: AppFonts.labelMedium.copyWith(color: AppColors.textSecondary),
        labelSmall: AppFonts.labelSmall.copyWith(color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkBlue,
          foregroundColor: AppColors.white,
          textStyle: AppFonts.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDarkBlue,
          textStyle: AppFonts.labelLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedColor: AppColors.primaryDarkBlue,
        selectedTileColor: AppColors.primaryBlue.withValues(alpha: 0.12),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        tileColor: Colors.transparent,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDarkBlue,
          side: const BorderSide(color: AppColors.primaryDarkBlue),
          textStyle: AppFonts.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.veryLightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDarkBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textHint),
        labelStyle: AppFonts.labelMedium.copyWith(color: AppColors.textPrimary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
  

