import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Mock LoginViewModel
class MockLoginViewModel extends Mock implements LoginViewModel {}

// Fake BuildContext for mocktail
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockLoginViewModel mockLoginViewModel;
  late SplashViewModel splashViewModel;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    splashViewModel = SplashViewModel(mockLoginViewModel);
  });

  testWidgets('SplashViewModel calls verifyUser on init', (tester) async {
    // Stub verifyUser to return Future<void>
    when(
      () => mockLoginViewModel.verifyUser(any()),
    ).thenAnswer((_) async => Future.value());

    // Build a minimal widget tree to get BuildContext
    final testWidget = MaterialApp(
      home: Builder(
        builder: (context) {
          splashViewModel.init(context); // call with real context
          return const SizedBox();
        },
      ),
    );

    await tester.pumpWidget(testWidget);

    // Verify verifyUser was called once
    verify(() => mockLoginViewModel.verifyUser(any())).called(1);
  });
}
