// test/home_view_test.dart

import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Replace with your actual imports
import 'package:chime/features/home/presentation/view/home_view.dart';
import 'package:chime/features/home/presentation/view_model/home_state.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';

// ✅ Correctly extending the type to fix analyzer error
class MockHomeViewModel extends Mock implements HomeViewModel {}

class FakeLoginViewModel extends Fake implements LoginViewModel {}

void main() {
  late MockHomeViewModel mockHomeViewModel;
  late LoginViewModel fakeLoginViewModel;

  setUpAll(() {
    // ✅ Required for null safety and when using Fake objects
    registerFallbackValue(FakeLoginViewModel());
  });

  setUp(() {
    mockHomeViewModel = MockHomeViewModel();
    fakeLoginViewModel = FakeLoginViewModel();
  });

  testWidgets('should display HomeView with correct UI', (tester) async {
    final state = HomeState(
      selectedIndex: 0,
      views: [const Text("Video Page"), const Text("Profile Page")],
      loginViewModel: fakeLoginViewModel,
    );

    when(() => mockHomeViewModel.state).thenReturn(state);
    when(
      () => mockHomeViewModel.stream,
    ).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeViewModel>.value(
          value: mockHomeViewModel,
          child: const HomeView(),
        ),
      ),
    );

    expect(find.text('Chime'), findsOneWidget);
    expect(find.text('Video Page'), findsOneWidget);
    expect(find.text('Profile Page'), findsNothing);
  });
}
