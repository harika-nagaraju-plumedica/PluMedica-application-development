import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:plumedica_application_development/bindings/doctor_dashboard_binding.dart';
import 'package:plumedica_application_development/bindings/doctor_patient_history_binding.dart';
import 'package:plumedica_application_development/bindings/doctor_prescriptions_binding.dart';
import 'package:plumedica_application_development/controllers/doctor_prescriptions_controller.dart';
import 'package:plumedica_application_development/views/doctor_dashboard_view.dart';
import 'package:plumedica_application_development/views/doctor_patient_history_view.dart';
import 'package:plumedica_application_development/views/doctor_prescriptions_view.dart';
import 'package:plumedica_application_development/views/doctor_registration_view.dart';
import 'package:plumedica_application_development/views/doctor_workflow_view.dart';

void main() {
  Widget buildDoctorTestApp(String initialRoute) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: '/doctor_dashboard',
          page: () => const DoctorDashboardView(),
          binding: DoctorDashboardBinding(),
        ),
        GetPage(
          name: '/doctor_workflow',
          page: () => const DoctorWorkflowView(),
        ),
        GetPage(
          name: '/doctor_patient_history',
          page: () => const DoctorPatientHistoryView(),
          binding: DoctorPatientHistoryBinding(),
        ),
        GetPage(
          name: '/doctor_prescriptions',
          page: () => const DoctorPrescriptionsView(),
          binding: DoctorPrescriptionsBinding(),
        ),
        GetPage(
          name: '/doctor_registration',
          page: () => const DoctorRegistrationView(),
        ),
      ],
    );
  }

  group('Doctor flow runtime checks', () {
    testWidgets('Dashboard opens workflow guide', (tester) async {
      await tester.pumpWidget(buildDoctorTestApp('/doctor_dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Workflow Guide'), findsOneWidget);
      await tester.dragUntilVisible(
        find.text('Doctor Workflow Guide'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Doctor Workflow Guide'));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Workflow'), findsOneWidget);
      expect(find.text('What To Do (Doctor Module)'), findsOneWidget);
    });

    testWidgets('Workflow step opens patient history', (tester) async {
      await tester.pumpWidget(buildDoctorTestApp('/doctor_workflow'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go To Patient History'));
      await tester.pumpAndSettle();

      expect(find.text('Patient History'), findsOneWidget);
    });

    testWidgets('Patient history Create Prescription passes patient context', (
      tester,
    ) async {
      await tester.pumpWidget(buildDoctorTestApp('/doctor_patient_history'));
      await tester.pumpAndSettle();

      expect(find.text('Create Prescription'), findsWidgets);
      await tester.tap(find.text('Create Prescription').first);
      await tester.pumpAndSettle();

      expect(find.text('Prescriptions'), findsOneWidget);

      final prescriptionsController = Get.find<DoctorPrescriptionsController>();
      expect(prescriptionsController.patientIdController.text, isNotEmpty);
      expect(prescriptionsController.patientNameController.text, isNotEmpty);
    });

    testWidgets('Prescription history opens Add Follow-up sheet', (tester) async {
      await tester.pumpWidget(buildDoctorTestApp('/doctor_prescriptions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('Add Follow-up'), findsWidgets);
      await tester.ensureVisible(find.text('Add Follow-up').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Follow-up').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Previous Prescription:'), findsOneWidget);
      expect(find.text('Save Follow-up'), findsOneWidget);
    });

    testWidgets('Prescription history opens Refer Doctor sheet', (tester) async {
      await tester.pumpWidget(buildDoctorTestApp('/doctor_prescriptions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Refer').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Refer').first);
      await tester.pumpAndSettle();

      expect(find.text('Refer Doctor'), findsOneWidget);
      expect(find.textContaining('Reason for referral'), findsOneWidget);
      expect(find.textContaining('Detailed Description'), findsOneWidget);
    });
  });
}
