import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Your showMySnackBar function
void showMySnackBar({
  required BuildContext context,
  required String message,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color ?? Colors.green,
    ),
  );
}

void main() {
  testWidgets('SnackBar appears and then disappears', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Hello')));
                  },
                  child: Text('Show'),
                ),
          ),
        ),
      ),
    );

    // Show SnackBar
    await tester.tap(find.text('Show'));
    await tester.pump();

    // SnackBar should be visible
    expect(find.byType(SnackBar), findsOneWidget);

    // Wait for SnackBar duration + dismissal animation
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // SnackBar should be gone
    expect(find.byType(SnackBar), findsNothing);
  });
}
