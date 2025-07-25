import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chime/features/auth/presentation/view/register_view.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:chime/core/common/google_signIn_button.dart';

// Dummy BuildContext for fallback value
class DummyBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock classes
class MockRegsiterViewModel extends Mock implements RegsiterViewModel {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late MockRegsiterViewModel mockRegsiterViewModel;
  late MockLoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(
      NavigateToLoginViewEvent(context: DummyBuildContext()),
    );
  });

  setUp(() {
    mockRegsiterViewModel = MockRegsiterViewModel();
    mockLoginViewModel = MockLoginViewModel();

    when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.value(LoginState.initial()));

    when(() => mockRegsiterViewModel.add(any())).thenReturn(null);
  });

  Future<void> pumpRegisterView(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<RegsiterViewModel>.value(value: mockRegsiterViewModel),
          BlocProvider<LoginViewModel>.value(value: mockLoginViewModel),
        ],
        child: const MaterialApp(home: RegisterView()),
      ),
    );
  }

  testWidgets('renders RegisterView UI elements', (tester) async {
    await pumpRegisterView(tester);

    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Sign up to continue'), findsOneWidget);
    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    final loginText = find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains('Login'),
    );
    expect(loginText, findsOneWidget);
  });

  testWidgets('shows loading indicator when state.isLoading is true', (
    tester,
  ) async {
    final loadingState = LoginState.initial().copyWith(isLoading: true);
    when(() => mockLoginViewModel.state).thenReturn(loadingState);
    when(
      () => mockLoginViewModel.stream,
    ).thenAnswer((_) => Stream.value(loadingState));

    await pumpRegisterView(tester);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(GoogleSignInButton), findsNothing);
  });
}
