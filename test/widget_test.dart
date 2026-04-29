import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:plumedica_application_development/main.dart';

void main() {
  testWidgets('App boots with GetMaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 6));

    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
