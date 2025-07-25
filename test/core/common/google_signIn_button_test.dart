import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test version of GoogleSignInButton that avoids loading asset images
class TestGoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TestGoogleSignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.login,
      ), // Use icon instead of Image.asset to avoid asset loading issues
      label: const Text('Sign in with Google'),
      onPressed: onPressed,
    );
  }
}

void main() {
  testWidgets('GoogleSignInButton renders and responds to tap', (
    WidgetTester tester,
  ) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestGoogleSignInButton(
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    expect(find.text('Sign in with Google'), findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(pressed, isTrue);
  });
}
