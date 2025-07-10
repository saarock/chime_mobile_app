import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/profile/presentation/view/profile_view.dart';
import 'package:chime/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:chime/features/video-call/presentation/view/video_call_view.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;
  final LoginViewModel loginViewModel;

  const HomeState({
    required this.selectedIndex,
    required this.views,
    required this.loginViewModel,
  });

  static HomeState initial(LoginViewModel loginViewModel) {
    return HomeState(
      selectedIndex: 0,
      loginViewModel: loginViewModel,
      views: [
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: serviceLocator<VideoBloc>()),
            BlocProvider.value(value: loginViewModel),
          ],
          child: const VideoCallView(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: loginViewModel),
            BlocProvider.value(value: serviceLocator<ProfileBloc>()),
          ],
          child: const ProfileView(),
        ),
      ],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      loginViewModel: loginViewModel,
    );
  }
}
