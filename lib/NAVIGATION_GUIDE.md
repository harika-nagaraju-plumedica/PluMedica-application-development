# Plumedica Navigation Guide

## Overview
Plumedica supports multiple user roles with dedicated navigation flows. After the splash screen, users are directed to a **Role Selection Screen** where they choose their role.

## Navigation Flow Architecture

```
Splash Screen
    ↓
Role Selection Screen
    ↓
    ├─ Patient Flow
    ├─ Hospital Flow
    ├─ Partner (Insurance) Flow
    ├─ Job Seeker Flow
    ├─ Employer Flow
    └─ Doctor Flow
```

---

## Role Selection Routes

### Route: `/role_selection`
**View:** `RoleSelectionView`
**Description:** Central hub for role selection with 6 role options displayed as interactive cards.

**Available Roles:**
1. **Patient** → Navigates to `/patient/registration`
2. **Hospital** → Navigates to `/hospital/registration`
3. **Insurance Partner** → Navigates to `/partner/registration`
4. **Job Seeker** → Navigates to `/jobs/job-seeker/registration`
5. **Employer** → Navigates to `/jobs/employer/registration`
6. **Doctor** → Navigates to `/doctor_registration`

---

## 1. PATIENT FLOW

### Registration & Authentication
- **Route:** `/patient/registration`
- **View:** `PatientRegistrationView`
- **Controller:** `PatientRegistrationController`
- **Binding:** `PatientRegistrationBinding`
- **Next:** `/patient/login` (on registration success)

- **Route:** `/patient/login`
- **View:** `PatientLoginView`
- **Controller:** `PatientLoginController`
- **Binding:** `PatientLoginBinding`
- **Next:** `/patient/dashboard` (on login success)

### Dashboard & Main Screens
- **Route:** `/patient/dashboard`
- **View:** `PatientDashboardView`
- **Controller:** `PatientDashboardController`
- **Binding:** `PatientDashboardBinding`
- **Quick Actions:** Medical History, Fitness, Health Records, Consultation, Pharmacy, SOS, Profile

### Feature Screens
- **Route:** `/patient/medical_history`
- **View:** `PatientMedicalHistoryView`
- **Controller:** `PatientMedicalHistoryController`

- **Route:** `/patient/fitness`
- **View:** `PatientFitnessView`
- **Controller:** `PatientFitnessController`

- **Route:** `/patient/health_records`
- **View:** `PatientHealthRecordsView`
- **Controller:** `PatientHealthRecordsController`

- **Route:** `/patient/consultation`
- **View:** `PatientConsultationView`
- **Controller:** `PatientConsultationController`

- **Route:** `/patient/pharmacy`
- **View:** `PatientPharmacyView`
- **Controller:** `PatientPharmacyController`

- **Route:** `/patient/sos`
- **View:** `PatientSosView`
- **Controller:** `PatientSosController`
- **Special:** Emergency button with animation

- **Route:** `/patient/profile`
- **View:** `PatientProfileView`
- **Controller:** `PatientProfileController`

---

## 2. HOSPITAL FLOW

### Registration & Authentication
- **Route:** `/hospital/registration`
- **View:** `HospitalRegistrationView`
- **Controller:** `HospitalRegistrationController`
- **Binding:** `HospitalRegistrationBinding`
- **Next:** `/hospital/login`

- **Route:** `/hospital/login`
- **View:** `HospitalLoginView`
- **Controller:** `HospitalLoginController`
- **Binding:** `HospitalLoginBinding`
- **Next:** `/hospital/dashboard`

### Dashboard & Management Screens
- **Route:** `/hospital/dashboard`
- **View:** `HospitalDashboardView`
- **Controller:** `HospitalDashboardController`
- **Dashboard Features:** Summary cards, quick stats, navigation tiles

- **Route:** `/hospital/consultant_management`
- **View:** `HospitalConsultantManagementView`
- **Controller:** `HospitalConsultantManagementController`

- **Route:** `/hospital/admission_management`
- **View:** `HospitalAdmissionManagementView`
- **Controller:** `HospitalAdmissionManagementController`

- **Route:** `/hospital/emergency_services`
- **View:** `HospitalEmergencyServicesView`
- **Controller:** `HospitalEmergencyServicesController`

- **Route:** `/hospital/patient_records`
- **View:** `HospitalPatientRecordsView`
- **Controller:** `HospitalPatientRecordsController`

- **Route:** `/hospital/payment_summary`
- **View:** `HospitalPaymentSummaryView`
- **Controller:** `HospitalPaymentSummaryController`

- **Route:** `/hospital/job_postings`
- **View:** `HospitalJobPostingsView`
- **Controller:** `HospitalJobPostingsController`

---

## 3. PARTNER (INSURANCE) FLOW

### Registration & Authentication
- **Route:** `/partner/registration`
- **View:** `PartnerRegistrationView`
- **Controller:** `PartnerRegistrationController`
- **Binding:** `PartnerRegistrationBinding`
- **Next:** `/partner/login`

- **Route:** `/partner/login`
- **View:** `PartnerLoginView`
- **Controller:** `PartnerLoginController`
- **Binding:** `PartnerLoginBinding`
- **Next:** `/partner/dashboard`

### Partner Management Screens
- **Route:** `/partner/dashboard`
- **View:** `PartnerDashboardView`
- **Controller:** `PartnerDashboardController`

- **Route:** `/partner/policies`
- **View:** `PartnerPoliciesView`
- **Controller:** `PartnerPoliciesController`

- **Route:** `/partner/claims`
- **View:** `PartnerClaimsView`
- **Controller:** `PartnerClaimsController`

- **Route:** `/partner/network`
- **View:** `PartnerNetworkView`
- **Controller:** `PartnerNetworkController`

- **Route:** `/partner/reports`
- **View:** `PartnerReportsView`
- **Controller:** `PartnerReportsController`

---

## 4. JOBS FLOW - JOB SEEKER

### Registration & Authentication
- **Route:** `/jobs/job-seeker/registration`
- **View:** `JobSeekerRegistrationView`
- **Controller:** `JobSeekerRegistrationController`
- **Binding:** `JobSeekerRegistrationBinding`
- **Next:** `/jobs/job-seeker/login`

- **Route:** `/jobs/job-seeker/login`
- **View:** `JobSeekerLoginView`
- **Controller:** `JobSeekerLoginController`
- **Binding:** `JobSeekerLoginBinding`
- **Next:** `/jobs/search`

### Job Search & Application
- **Route:** `/jobs/search`
- **View:** `JobSearchView`
- **Controller:** `JobSearchController`
- **Features:** Job search, filtering, sorting

- **Route:** `/jobs/listing`
- **View:** `JobListingView`
- **Controller:** `JobListingController`

- **Route:** `/jobs/detail`
- **View:** `JobDetailView`
- **Controller:** `JobDetailController`
- **Features:** Full job description, apply button

- **Route:** `/jobs/applications`
- **View:** `ApplicationStatusView`
- **Controller:** `ApplicationStatusController`
- **Features:** Track application status, interview dates

---

## 5. JOBS FLOW - EMPLOYER

### Registration & Authentication
- **Route:** `/jobs/employer/registration`
- **View:** `EmployerRegistrationView`
- **Controller:** `EmployerRegistrationController`
- **Binding:** `EmployerRegistrationBinding`
- **Next:** `/jobs/employer/login`

- **Route:** `/jobs/employer/login`
- **View:** `EmployerLoginView`
- **Controller:** `EmployerLoginController`
- **Binding:** `EmployerLoginBinding`
- **Next:** `/jobs/employer/post-job` or dashboard

### Job Management
- **Route:** `/jobs/employer/post-job`
- **View:** `JobPostingCreationView`
- **Controller:** `JobPostingCreationController`
- **Binding:** `JobPostingCreationBinding`

- **Route:** `/jobs/employer/candidates`
- **View:** `CandidateListView`
- **Controller:** `CandidateListController`
- **Binding:** `CandidateListBinding`

- **Route:** `/jobs/employer/candidate-detail`
- **View:** `CandidateDetailView`
- **Controller:** `CandidateDetailController`
- **Binding:** `CandidateDetailBinding`

---

## 6. DOCTOR FLOW

### Registration & Authentication
- **Route:** `/doctor_registration`
- **View:** `DoctorRegistrationView`
- **Controller:** `DoctorRegistrationController`
- **Binding:** `DoctorRegistrationBinding`
- **Next:** `/doctor_login`

- **Route:** `/doctor_login`
- **View:** `DoctorLoginView`
- **Controller:** `DoctorLoginController`
- **Binding:** `DoctorLoginBinding`
- **Next:** `/doctor_dashboard`

### Dashboard & Management
- **Route:** `/doctor_dashboard`
- **View:** `DoctorDashboardView`
- **Controller:** `DoctorDashboardController`

- **Route:** `/doctor_appointments`
- **View:** `DoctorAppointmentsView`
- **Controller:** `DoctorAppointmentsController`

- **Route:** `/doctor_patient_history`
- **View:** `DoctorPatientHistoryView`
- **Controller:** `DoctorPatientHistoryController`

- **Route:** `/doctor_prescriptions`
- **View:** `DoctorPrescriptionsView`
- **Controller:** `DoctorPrescriptionsController`

- **Route:** `/doctor_payments`
- **View:** `DoctorPaymentsView`
- **Controller:** `DoctorPaymentsController`

---

## Navigation Implementation Examples

### Navigate to Patient Dashboard
```dart
Get.toNamed('/patient/dashboard');
```

### Navigate with Arguments
```dart
Get.toNamed('/patient/medical_history', arguments: {
  'patientId': '12345',
  'date': '2026-04-17'
});
```

### Pop Back to Previous Screen
```dart
Get.back();
```

### Replace Current Screen
```dart
Get.offNamed('/patient/dashboard');
```

### Navigate and Remove All Previous Screens
```dart
Get.offAllNamed('/patient/dashboard');
```

## Transition Types
All routes use `Transition.rightToLeft` (slide from right) except role selection which uses `Transition.fadeIn` (fade).

---

## Design System Integration
- **Colors:** AppColors utility for consistent theming
- **Fonts:** AppFonts utility for typography
- **Constants:** AppConstants for spacing and sizing
- **Bindings:** All routes use GetX bindings for dependency injection
- **State Management:** GetxController for reactive state

---

## Key Features by Role

### Patient
- ✅ Health tracking
- ✅ Doctor consultations
- ✅ Medication management
- ✅ Emergency SOS
- ✅ Medical records

### Hospital
- ✅ Admission management
- ✅ Consultant management
- ✅ Emergency services
- ✅ Payment processing
- ✅ Job postings

### Partner
- ✅ Claim management
- ✅ Policy management
- ✅ Network hospital management
- ✅ Analytics & reports

### Job Seeker
- ✅ Job search & filtering
- ✅ Application tracking
- ✅ Interview scheduling

### Employer
- ✅ Job posting creation
- ✅ Candidate management
- ✅ Application review

### Doctor
- ✅ Appointment management
- ✅ Prescription management
- ✅ Patient history access
- ✅ Payment tracking

---

## Navigation Controller Methods

```dart
// Go to role selection screen
navigationController.goToRoleSelection();

// Go to login screen
navigationController.goToLogin();

// Go to home screen
navigationController.goToHome();

// Logout (goes back to login)
navigationController.logout();
```

---

## Error Handling & Fallbacks
- All routes properly initialize their bindings
- Controllers handle loading states
- Empty states displayed when no data available
- Error snackbars for failed operations

---

## Future Enhancements
- [ ] Deep linking support
- [ ] Route history/analytics
- [ ] Persistent navigation state
- [ ] Role-based route guards
- [ ] Dynamic bottom navigation per role
