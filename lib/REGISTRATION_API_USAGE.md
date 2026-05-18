# Registration API Usage

## Base URL
Configured in lib/services/api_endpoints.dart using:
- --dart-define=BASE_URL=https://your-api-host.com

## JSON vs Multipart
- JSON APIs use RegistrationService + DioService.postJson
- Multipart APIs use RegistrationService + DioService.postMultipart
- availabilitySlots is serialized with jsonEncode before upload

## How to Call Each API from UI

1. Doctor
- Call: RegistrationService.registerDoctor(...)
- Controller: DoctorRegistrationController.submitRegistration()

2. Patient
- Call: RegistrationService.registerPatient(...)
- Controller: PatientRegistrationController.register()

3. Hospital
- Call: RegistrationService.registerHospital(...)
- Controller: HospitalRegistrationController.submitRegistration()

4. Pharmacy
- Call: RegistrationService.registerPharmacy(...)
- Controller: PharmacyRegistrationController.submitRegistration()

5. Employer
- Call: RegistrationService.registerEmployer(...)
- Controller: EmployerRegistrationController.register()

6. Partner Organization
- Call: RegistrationService.registerPartnerOrganization(...)
- Controller: PartnerRegistrationController.register()

7. Diagnostics Center
- Call: RegistrationService.registerDiagnosticsCenter(...)
- Controller: DiagnosticsRegistrationController.submitRegistration()

## Token Storage
- JWT is read from response.data.token
- Persisted in TokenStorageService via shared_preferences
- Key: auth_jwt_token

## Error Handling
- API and network errors are mapped to ApiException
- Controllers catch ApiException and show user-facing snackbars
- Backend error payload message is surfaced directly when available
