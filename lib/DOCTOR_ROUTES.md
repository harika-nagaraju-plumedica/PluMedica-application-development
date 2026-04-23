/// Doctor Routes Configuration
///
/// Add the following routes to your main GetMaterialApp routes in main.dart:

/// ```dart
/// import 'package:get/get.dart';
/// import 'bindings/doctor_registration_binding.dart';
/// import 'bindings/doctor_login_binding.dart';
/// import 'bindings/doctor_dashboard_binding.dart';
/// import 'bindings/doctor_appointments_binding.dart';
/// import 'bindings/doctor_patient_history_binding.dart';
/// import 'bindings/doctor_prescriptions_binding.dart';
/// import 'bindings/doctor_payments_binding.dart';
/// import 'views/doctor_registration_view.dart';
/// import 'views/doctor_login_view.dart';
/// import 'views/doctor_dashboard_view.dart';
/// import 'views/doctor_appointments_view.dart';
/// import 'views/doctor_patient_history_view.dart';
/// import 'views/doctor_prescriptions_view.dart';
/// import 'views/doctor_payments_view.dart';
///
/// // In your GetMaterialApp:
/// getPages: [
///   // ... existing routes ...
///
///   // Doctor Flow Routes
///   GetPage(
///     name: '/doctor_registration',
///     page: () => const DoctorRegistrationView(),
///     binding: DoctorRegistrationBinding(),
///   ),
///   GetPage(
///     name: '/doctor_login',
///     page: () => const DoctorLoginView(),
///     binding: DoctorLoginBinding(),
///   ),
///   GetPage(
///     name: '/doctor_dashboard',
///     page: () => const DoctorDashboardView(),
///     binding: DoctorDashboardBinding(),
///   ),
///   GetPage(
///     name: '/doctor_appointments',
///     page: () => const DoctorAppointmentsView(),
///     binding: DoctorAppointmentsBinding(),
///   ),
///   GetPage(
///     name: '/doctor_patient_history',
///     page: () => const DoctorPatientHistoryView(),
///     binding: DoctorPatientHistoryBinding(),
///   ),
///   GetPage(
///     name: '/doctor_prescriptions',
///     page: () => const DoctorPrescriptionsView(),
///     binding: DoctorPrescriptionsBinding(),
///   ),
///   GetPage(
///     name: '/doctor_payments',
///     page: () => const DoctorPaymentsView(),
///     binding: DoctorPaymentsBinding(),
///   ),
/// ],
/// ```

/// Navigation Examples:
/// 
/// 1. Navigate to Doctor Registration:
///    Get.toNamed('/doctor_registration')
///
/// 2. Navigate to Doctor Login:
///    Get.toNamed('/doctor_login')
///
/// 3. Navigate to Doctor Dashboard:
///    Get.toNamed('/doctor_dashboard')
///
/// 4. Navigate to Appointments:
///    Get.toNamed('/doctor_appointments')
///
/// 5. Navigate to Patient History:
///    Get.toNamed('/doctor_patient_history')
///
/// 6. Navigate to Prescriptions:
///    Get.toNamed('/doctor_prescriptions')
///
/// 7. Navigate to Payments:
///    Get.toNamed('/doctor_payments')
