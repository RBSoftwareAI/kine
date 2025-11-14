// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinecare/main.dart';

void main() {
  testWidgets('KinéCare app initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KineCareApp());

    // Verify that the app starts with login or loading screen
    await tester.pumpAndSettle();
    
    // Should find either loading indicator or login screen
    expect(
      find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
      find.text('KinéCare').evaluate().isNotEmpty,
      true,
    );
  });
}
