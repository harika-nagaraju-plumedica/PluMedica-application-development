# Plumedica Widgets Guide

All reusable widgets are now available in `/lib/widgets/`. Import them easily using the barrel file:

```dart
import '../widgets/index.dart';
```

## Available Widgets

### 1. **AppButton**
Custom button with loading state support.

```dart
AppButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: false,
  isEnabled: true,
  backgroundColor: AppColors.primaryDarkBlue,
  width: double.infinity,
  height: 48,
)
```

### 2. **AppTextField**
Custom text field with validation.

```dart
AppTextField(
  hint: 'Enter your name',
  onChanged: (value) {},
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

### 3. **AuthButton**
Specialized button for authentication screens.

```dart
AuthButton(
  text: 'Sign In',
  onPressed: () {},
)
```

## Card Widgets

### 4. **DoctorProfileCard**
Displays doctor profile with gradient background.

```dart
DoctorProfileCard(
  doctor: doctorModel,
)
```

Props:
- `doctor`: Doctor model instance

### 5. **StatCard**
Displays statistics with icon and color coding.

```dart
StatCard(
  label: 'Patients',
  value: '42',
  icon: Icons.people,
  backgroundColor: AppColors.primaryBlue,
)
```

Props:
- `label`: String - the label text
- `value`: String - the value to display
- `icon`: IconData - the icon to show
- `backgroundColor`: Color - the accent color

### 6. **AppointmentCard**
Displays appointment information with status.

```dart
AppointmentCard(
  appointment: appointmentModel,
  onTap: () {},
  onMarkComplete: () {},
)
```

Props:
- `appointment`: Appointment model
- `onTap`: Callback when tapped
- `onMarkComplete`: Optional callback to mark complete

### 7. **PrescriptionCard**
Shows prescription details with edit/delete options.

```dart
PrescriptionCard(
  prescription: prescriptionModel,
  onTap: () {},
  onEdit: () {},
  onDelete: () {},
  isEditable: true,
)
```

Props:
- `prescription`: Prescription model
- `onTap`: Callback when tapped
- `onEdit`: Optional edit callback
- `onDelete`: Optional delete callback
- `isEditable`: Boolean to show edit menu

### 8. **PaymentCard**
Displays payment/transaction information.

```dart
PaymentCard(
  payment: paymentModel,
  onTap: () {},
  onDownloadInvoice: () {},
)
```

Props:
- `payment`: Payment model
- `onTap`: Callback when tapped
- `onDownloadInvoice`: Optional invoice download callback

### 9. **PatientHistoryCard**
Shows patient medical history summary.

```dart
PatientHistoryCard(
  patientId: 'P123',
  patientName: 'John Doe',
  visitDate: DateTime.now(),
  diagnosis: 'Fever',
  onTap: () {},
)
```

Props:
- `patientId`: String - patient identifier
- `patientName`: String - patient name
- `visitDate`: DateTime - visit date
- `diagnosis`: String - diagnosis description
- `onTap`: Callback when tapped

## State Widgets

### 10. **LoadingStateWidget**
Shows loading indicator with optional message.

```dart
// Full screen loading
const LoadingStateWidget(
  message: 'Loading data...',
  fullScreen: true,
)

// Inline loading
const LoadingStateWidget(
  message: 'Processing...',
  fullScreen: false,
)
```

### 11. **EmptyStateWidget**
Displays empty state with icon and optional retry.

```dart
EmptyStateWidget(
  message: 'No appointments found',
  icon: Icons.calendar_today,
  onRetry: () {},
  retryButtonText: 'Retry',
)
```

### 12. **ErrorStateWidget**
Shows error message with retry option.

```dart
ErrorStateWidget(
  message: 'Failed to load data',
  onRetry: () {},
  retryButtonText: 'Retry',
  icon: Icons.error_outline,
)
```

## Utility Widgets

### 13. **SectionHeader**
Header for content sections with optional "View All" link.

```dart
SectionHeader(
  title: 'Recent Appointments',
  subtitle: 'Your upcoming appointments',
  onViewAll: () {},
)
```

Props:
- `title`: String - main title
- `subtitle`: String - optional subtitle
- `onViewAll`: Optional callback for view all

### 14. **CustomAppBar**
Reusable app bar with logout button.

```dart
Scaffold(
  appBar: CustomAppBar(
    title: 'Doctor Dashboard',
    onLogout: controller.logout,
    showLogout: true,
    actions: [
      IconButton(icon: Icon(Icons.settings), onPressed: () {}),
    ],
  ),
  // ...
)
```

Props:
- `title`: String - app bar title
- `onLogout`: Optional logout callback
- `actions`: Optional additional actions
- `showLogout`: Boolean to show logout button

## Usage Example

```dart
import 'package:flutter/material.dart';
import '../widgets/index.dart';

class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Screen',
        onLogout: () {},
      ),
      body: ListView(
        children: [
          SectionHeader(
            title: 'Statistics',
          ),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Total',
                  value: '100',
                  icon: Icons.check,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          SectionHeader(
            title: 'Appointments',
          ),
          AppointmentCard(
            appointment: appointment,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
```

## Integration Steps

1. **Import widgets barrel file**:
   ```dart
   import '../widgets/index.dart';
   ```

2. **Replace inline UI with widgets** in your views

3. **Update refactored views** to use the new widgets

4. **Test** all screens to ensure proper rendering

## Benefits

✅ **Reusable** - Consistent components across the app  
✅ **Maintainable** - Changes in one place affect all usages  
✅ **Type-safe** - Full type safety with model parameters  
✅ **Themable** - Easy to customize through props  
✅ **Accessible** - Semantic and accessible components  

## Customization

Use the `backgroundColor`, `color`, and other props to customize widgets:

```dart
StatCard(
  label: 'Custom',
  value: 'Value',
  icon: Icons.custom_icon,
  backgroundColor: MyCustomColor,
)
```

## Notes

- All widgets follow Material Design 3 guidelines
- Colors use centralized `AppColors` constants
- Typography uses `AppFonts` for consistency
- Spacing uses `AppConstants` for uniform layouts
