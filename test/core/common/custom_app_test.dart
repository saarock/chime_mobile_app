import 'package:chime/core/common/custom_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomAppBar displays title and optional actions', (
    WidgetTester tester,
  ) async {
    // Build widget with title and no actions
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(appBar: const CustomAppBar(title: 'Test Title')),
      ),
    );

    // Verify title text is found
    expect(find.text('Test Title'), findsOneWidget);

    // Verify no actions by default
    expect(find.byType(IconButton), findsNothing);

    // Now test with action buttons
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'Test Title',
            actions: [
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    // Verify title text still present
    expect(find.text('Test Title'), findsOneWidget);

    // Verify the two IconButtons in actions are present
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
