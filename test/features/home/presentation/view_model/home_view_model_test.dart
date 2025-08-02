// test/features/home/presentation/view_model/home_view_model_test.dart

import 'package:chime/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:chime/features/home/presentation/view_model/home_state.dart';

import '../../../../mocks.dart'; // Only this mocks import

void main() {
  final serviceLocator = GetIt.instance;

  late MockLoginViewModel mockLoginViewModel;
  late MockVideoBloc mockVideoBloc;
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    mockVideoBloc = MockVideoBloc();
    mockProfileBloc = MockProfileBloc();

    // Register mocks in GetIt
    if (!serviceLocator.isRegistered<VideoBloc>()) {
      serviceLocator.registerSingleton<VideoBloc>(mockVideoBloc);
    }

    if (!serviceLocator.isRegistered<ProfileBloc>()) {
      serviceLocator.registerSingleton<ProfileBloc>(mockProfileBloc);
    }
  });

  tearDown(() {
    serviceLocator.reset();
  });

  blocTest<HomeViewModel, HomeState>(
    'emits new state when tab is changed',
    build: () => HomeViewModel(loginViewModel: mockLoginViewModel),
    act: (viewModel) => viewModel.onTabTapped(1),
    expect:
        () => [
          isA<HomeState>().having(
            (state) => state.selectedIndex,
            'selectedIndex',
            1,
          ),
        ],
  );
}
