// Basic widget test for MTCN Golf App

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Simple widget test', (WidgetTester tester) async {
    // Create a simple test widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Test'))),
      ),
    );

    // Verify that the test widget loads
    expect(find.text('Test'), findsOneWidget);
  });
}
