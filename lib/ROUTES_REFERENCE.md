# Navigation Routes Reference

## Quick Route Lookup

### Entry Points
| Route | View | Purpose |
|-------|------|---------|
| `/role_selection` | RoleSelectionView | Role selection hub (accessed after splash) |
| `/` (home) | SplashView | Initial app screen |

---

## PATIENT FLOW Routes

| Route | View | Controller |
|-------|------|-----------|
| `/patient/registration` | PatientRegistrationView | PatientRegistrationController |
| `/patient/login` | PatientLoginView | PatientLoginController |
| `/patient/dashboard` | PatientDashboardView | PatientDashboardController |
| `/patient/medical_history` | PatientMedicalHistoryView | PatientMedicalHistoryController |
| `/patient/fitness` | PatientFitnessView | PatientFitnessController |
| `/patient/health_records` | PatientHealthRecordsView | PatientHealthRecordsController |
| `/patient/consultation` | PatientConsultationView | PatientConsultationController |
| `/patient/pharmacy` | PatientPharmacyView | PatientPharmacyController |
| `/patient/sos` | PatientSosView | PatientSosController |
| `/patient/profile` | PatientProfileView | PatientProfileController |

---

## HOSPITAL FLOW Routes

| Route | View | Controller |
|-------|------|-----------|
| `/hospital/registration` | HospitalRegistrationView | HospitalRegistrationController |
| `/hospital/login` | HospitalLoginView | HospitalLoginController |
| `/hospital/dashboard` | HospitalDashboardView | HospitalDashboardController |
| `/hospital/consultant_management` | HospitalConsultantManagementView | HospitalConsultantManagementController |
| `/hospital/admission_management` | HospitalAdmissionManagementView | HospitalAdmissionManagementController |
| `/hospital/emergency_services` | HospitalEmergencyServicesView | HospitalEmergencyServicesController |
| `/hospital/patient_records` | HospitalPatientRecordsView | HospitalPatientRecordsController |
| `/hospital/payment_summary` | HospitalPaymentSummaryView | HospitalPaymentSummaryController |
| `/hospital/job_postings` | HospitalJobPostingsView | HospitalJobPostingsController |

---

## PARTNER FLOW Routes

| Route | View | Controller |
|-------|------|-----------|
| `/partner/registration` | PartnerRegistrationView | PartnerRegistrationController |
| `/partner/login` | PartnerLoginView | PartnerLoginController |
| `/partner/dashboard` | PartnerDashboardView | PartnerDashboardController |
| `/partner/policies` | PartnerPoliciesView | PartnerPoliciesController |
| `/partner/claims` | PartnerClaimsView | PartnerClaimsController |
| `/partner/network` | PartnerNetworkView | PartnerNetworkController |
| `/partner/reports` | PartnerReportsView | PartnerReportsController |

---

## JOBS FLOW - JOB SEEKER Routes

| Route | View | Controller |
|-------|------|-----------|
| `/jobs/job-seeker/registration` | JobSeekerRegistrationView | JobSeekerRegistrationController |
| `/jobs/job-seeker/login` | JobSeekerLoginView | JobSeekerLoginController |
| `/jobs/search` | JobSearchView | JobSearchController |
| `/jobs/listing` | JobListingView | JobListingController |
| `/jobs/detail` | JobDetailView | JobDetailController |
| `/jobs/applications` | ApplicationStatusView | ApplicationStatusController |

---

## JOBS FLOW - EMPLOYER Routes

| Route | View | Controller |
|-------|------|-----------|
| `/jobs/employer/registration` | EmployerRegistrationView | EmployerRegistrationController |
| `/jobs/employer/login` | EmployerLoginView | EmployerLoginController |
| `/jobs/employer/post-job` | JobPostingCreationView | JobPostingCreationController |
| `/jobs/employer/candidates` | CandidateListView | CandidateListController |
| `/jobs/employer/candidate-detail` | CandidateDetailView | CandidateDetailController |

---

## DOCTOR FLOW Routes

| Route | View | Controller |
|-------|------|-----------|
| `/doctor_registration` | DoctorRegistrationView | DoctorRegistrationController |
| `/doctor_login` | DoctorLoginView | DoctorLoginController |
| `/doctor_dashboard` | DoctorDashboardView | DoctorDashboardController |
| `/doctor_appointments` | DoctorAppointmentsView | DoctorAppointmentsController |
| `/doctor_patient_history` | DoctorPatientHistoryView | DoctorPatientHistoryController |
| `/doctor_prescriptions` | DoctorPrescriptionsView | DoctorPrescriptionsController |
| `/doctor_payments` | DoctorPaymentsView | DoctorPaymentsController |

---

## Common Navigation Patterns

### Sign Up → Login → Dashboard Flow
```dart
// After registration success:
Get.toNamed('/patient/login');

// After login success:
Get.toNamed('/patient/dashboard');
```

### Dashboard → Feature Screen
```dart
Get.toNamed('/patient/medical_history');
```

### Back to Previous Screen
```dart
Get.back();
```

### Logout Flow
```dart
// Option 1: Using controller
navigationController.logout();

// Option 2: Manual navigation
Get.offAllNamed('/role_selection');
```

---

## Route Transitions
- **Default:** `Transition.rightToLeft` (slide from right)
- **Role Selection:** `Transition.fadeIn` (fade effect)
- **Splash to Role Selection:** `Transition.fadeIn` (fade effect)

---

## File Organization

```
lib/
├── bindings/
│   ├── doctor_*.dart
│   ├── patient/
│   │   └── patient_*.dart
│   ├── hospital/
│   │   └── hospital_*.dart
│   ├── partner/
│   │   └── partner_*.dart
│   └── jobs/
│       └── jobs_*.dart
├── views/
│   ├── doctor_*.dart
│   ├── patient/
│   │   └── patient_*.dart
│   ├── hospital/
│   │   └── hospital_*.dart
│   ├── partner/
│   │   └── partner_*.dart
│   ├── jobs/
│   │   └── jobs_*.dart
│   ├── role_selection_view.dart
│   └── splash_view.dart
├── controllers/
│   ├── doctor_*.dart
│   ├── patient/
│   │   └── patient_*.dart
│   ├── hospital/
│   │   └── hospital_*.dart
│   ├── partner/
│   │   └── partner_*.dart
│   ├── jobs/
│   │   └── jobs_*.dart
│   └── navigation_controller.dart
└── main.dart
```

---

## Testing Navigation

### Unit Test Example
```dart
test('Navigate to patient dashboard', () {
  final route = GetPage(
    name: '/patient/dashboard',
    page: () => const PatientDashboardView(),
    binding: PatientDashboardBinding(),
  );
  expect(route.name, equals('/patient/dashboard'));
});
```

### Route Count
- **Total Routes:** 71
- **Patient Routes:** 10
- **Hospital Routes:** 9
- **Partner Routes:** 7
- **Job Seeker Routes:** 6
- **Employer Routes:** 5
- **Doctor Routes:** 7
- **Special Routes:** 2 (role selection + splash)

---

## Debugging Navigation

### Enable Route Logging
Add to main.dart GetMaterialApp:
```dart
GetMaterialApp(
  // ... other config
  enableLog: true,
)
```

### Check Current Route
```dart
print('Current route: ${Get.currentRoute}');
```

### View Route History
GetX maintains route history that can be accessed via Get.back()
