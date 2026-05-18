# REST API Integration Complete (Production-Ready)

This file documents a complete implementation of patient Dashboard and Profile REST APIs using Dio + Provider with clean architecture and strict null-safe parsing.

## 1) Implemented Architecture

Folder layout used:

```text
lib/
        models/
                dashboard_model.dart
                profile_model.dart
                generic_api_response.dart
        services/
                patient_api_config.dart
                patient_api_exception.dart
                patient_api_service.dart
        repositories/
                dashboard_repository.dart
                profile_repository.dart
        viewmodels/
                patient_dashboard_viewmodel.dart
                patient_profile_viewmodel.dart
        screens/
                patient_api_dashboard_screen.dart
                patient_api_profile_screen.dart
```

Integrated in routing:

- `/patient/api/dashboard`
- `/patient/api/profile`

## 2) Dependency Added

Updated `pubspec.yaml`:

```yaml
provider: ^6.1.2
```

## 3) API Configuration (No Hardcoding)

Configured with `--dart-define`:

- `BASE_URL`
- `PATIENT_TOKEN`

Implemented in `patient_api_config.dart` using `String.fromEnvironment`.

Run example:

```bash
flutter run --dart-define=BASE_URL=https://your-api-domain.com --dart-define=PATIENT_TOKEN=your_patient_jwt_token
```

## 4) Dio Service Features Implemented

In `patient_api_service.dart`:

- Base URL from config
- Interceptor for bearer token
- Request/response/error logging in debug mode
- Timeout handling (connect/receive/send)
- Status code handling for:
        - `200` success
        - `400` bad request
        - `401` unauthorized
        - `500+` server error
- Null-safe response mapping and defensive fallbacks

## 5) Models Implemented

### Dashboard Model

`dashboard_model.dart` includes:

- `DashboardModel`
- `DashboardPatient`
- `DashboardSummary`
- `LatestMetrics`
- `HeartRateMetric`

Null-safe parsing included for:

- `weight: null`
- `oxygenLevel: null`
- `measuredAt: {}`

### Profile Model

`profile_model.dart` includes:

- `ProfileModel`
- `PatientProfile`
- `ProfileUpdateRequest`

Safe parsing for `dob`:

```dart
dob: json['dob'] is String ? json['dob'] as String : null,
```

## 6) Generic API Wrapper

`generic_api_response.dart` includes reusable generic response mapping:

```json
{
        "success": true,
        "message": "...",
        "data": {...}
}
```

Supports custom `fromData` parser per endpoint.

## 7) Repository Layer

Created:

- `dashboard_repository.dart`
- `profile_repository.dart`

Responsibilities:

- Call service methods
- Parse generic response envelope
- Convert payloads into strongly typed models
- Throw domain-level exceptions when `success` is false

## 8) ViewModel Layer (Provider)

Created:

- `patient_dashboard_viewmodel.dart`
- `patient_profile_viewmodel.dart`

Capabilities:

- Fetch dashboard
- Fetch profile
- Update profile
- Maintain `loading / success / error` states
- Validate update payload before API call
- Never crash on null payload fields

## 9) UI Screens

Created:

- `patient_api_dashboard_screen.dart`
- `patient_api_profile_screen.dart`

### Dashboard UI

- Patient name and generated ID
- Summary cards (upcoming appointments, medications, reports)
- Latest metrics section
- Pull-to-refresh
- Retry state on failures

### Profile UI

- Fetch profile data and pre-fill fields
- Edit mode toggle
- Update form (fullName, mobile, gender, bloodGroup, address, dob)
- Date picker for DOB with `YYYY-MM-DD`
- Success/error feedback

## 10) Route Integration

In `main.dart`, added imports and routes:

```dart
import 'screens/patient_api_dashboard_screen.dart';
import 'screens/patient_api_profile_screen.dart';
```

```dart
GetPage(
        name: '/patient/api/dashboard',
        page: () => const PatientApiDashboardScreen(),
),
GetPage(
        name: '/patient/api/profile',
        page: () => const PatientApiProfileScreen(),
),
```

## 11) Error Handling Strategy

Implemented custom exception in `patient_api_exception.dart`:

- `PatientApiErrorType.badRequest`
- `PatientApiErrorType.unauthorized`
- `PatientApiErrorType.server`
- `PatientApiErrorType.timeout`
- `PatientApiErrorType.network`
- `PatientApiErrorType.parsing`
- `PatientApiErrorType.unknown`

All layers use try/catch with user-safe messages.

## 12) Endpoints Implemented

### GET Dashboard

- Endpoint: `/api/patient/dashboard`
- Implemented in `DashboardRepository.fetchDashboard()`

### GET Profile

- Endpoint: `/api/patient/profile`
- Implemented in `ProfileRepository.fetchProfile()`

### PUT Update Profile

- Endpoint: `/api/patient/profile`
- Implemented in `ProfileRepository.updateProfile()`

## 13) Null Safety Protections Added

Handled all risky backend payload patterns:

- Empty object fields (for example `dob: {}`)
- Nullable numeric fields (`weight`, `oxygenLevel`)
- Missing nested maps
- Empty strings and invalid dynamic values

## 14) How To Run

1. `flutter pub get`
2. `flutter run --dart-define=BASE_URL=https://your-api-domain.com --dart-define=PATIENT_TOKEN=your_patient_jwt_token`
3. Open route `/patient/api/dashboard`
4. Tap profile icon to open `/patient/api/profile`

## 15) Scalability Notes

This design is ready for growth:

- Add more repositories per feature
- Add request/response DTOs without touching UI
- Add token refresh in interceptor centrally
- Reuse generic response wrapper across modules

## 16) Files Added/Updated

Added:

- `lib/models/generic_api_response.dart`
- `lib/models/dashboard_model.dart`
- `lib/models/profile_model.dart`
- `lib/services/patient_api_config.dart`
- `lib/services/patient_api_exception.dart`
- `lib/services/patient_api_service.dart`
- `lib/repositories/dashboard_repository.dart`
- `lib/repositories/profile_repository.dart`
- `lib/viewmodels/patient_dashboard_viewmodel.dart`
- `lib/viewmodels/patient_profile_viewmodel.dart`
- `lib/screens/patient_api_dashboard_screen.dart`
- `lib/screens/patient_api_profile_screen.dart`

Updated:

- `pubspec.yaml`
- `lib/main.dart`
- `lib/INTEGRATION_COMPLETE.md`
