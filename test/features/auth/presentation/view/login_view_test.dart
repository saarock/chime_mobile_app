import 'package:chime/core/common/google_signIn_button.dart';
import 'package:chime/features/auth/presentation/view/login_view.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock the LoginViewModel
class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();

    // When state is called, return initial state
    when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());

    // Stub the stream of states for BlocBuilder
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.value(LoginState.initial()));
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginViewModel>.value(
          value: mockLoginViewModel,
          child: const LoginView(),
        ),
      ),
    );
  }

  testWidgets('renders GoogleSignInButton when not loading', (tester) async {
    await pumpLoginView(tester);

    // Verify GoogleSignInButton is found
    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    // Override state and stream to loading
    final loadingState = LoginState.initial().copyWith(isLoading: true);
    when(() => mockLoginViewModel.state).thenReturn(loadingState);
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.value(loadingState));

    await pumpLoginView(tester);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(GoogleSignInButton), findsNothing);
  });
  testWidgets('tapping Register triggers NavigateToRegisterViewEvent', (
    tester,
  ) async {
    await pumpLoginView(tester);

    final registerText = find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains('Register'),
    );
    expect(registerText, findsOneWidget);

    await tester.tap(registerText);
    await tester.pump();

    verify(
      () =>
          mockLoginViewModel.add(any(that: isA<NavigateToRegisterViewEvent>())),
    ).called(1);
  });
}
