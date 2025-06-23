// All the import statement starts
import 'package:chime/app/app.dart';
import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Main entry point of the Chime App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<LoginViewModel>()),
        BlocProvider(create: (_) => serviceLocator<RegsiterViewModel>()),
        BlocProvider(create: (_) => serviceLocator<HomeViewModel>()),
        BlocProvider(create: (_) => serviceLocator<VideoBloc>()),
      ],
      child: const App(),
    ),
  );
}
