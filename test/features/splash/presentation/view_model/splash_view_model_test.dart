import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Your other imports here

class MockLoginViewModel extends Mock implements LoginViewModel {}

// Fake BuildContext for mocktail fallback
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  late MockLoginViewModel mockLoginViewModel;
  late SplashViewModel splashViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    splashViewModel = SplashViewModel(mockLoginViewModel);
  });

  testWidgets('SplashViewModel calls verifyUser on init', (tester) async {
    when(() => mockLoginViewModel.verifyUser(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            splashViewModel.init(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    verify(() => mockLoginViewModel.verifyUser(any())).called(1);
  });
}
