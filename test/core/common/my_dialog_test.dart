import 'package:chime/features/home/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('myDialog displays title, content, actions and returns result', (
    WidgetTester tester,
  ) async {
    bool? dialogResult;

    // Create a test widget with a button to trigger the dialog
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      dialogResult = await myDialog(
                        context,
                        title: 'Test Title',
                        content: 'Test content here',
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('No'),
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                ),
              ),
        ),
      ),
    );

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify the dialog is shown with correct title and content
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test content here'), findsOneWidget);

    // Verify the action buttons exist
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    // Tap 'Yes' and verify dialog closes with result true
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(dialogResult, true);

    // Now show the dialog again to test 'No' button
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Tap 'No' and verify dialog closes with result false
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(dialogResult, false);
  });
}
