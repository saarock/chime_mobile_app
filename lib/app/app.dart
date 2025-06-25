import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/app/theme/my_theme.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/splash/presentation/view/splah_screen_view.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginViewModel>(
      // ✅ Global LoginViewModel instance
      create: (_) => serviceLocator<LoginViewModel>(),
      child: MaterialApp(
        theme: getMyTheme(),
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          // ✅ Reuse the above LoginViewModel
          create: (context) => SplashViewModel(context.read<LoginViewModel>()),
          child: const SplashScreenView(),
        ),
      ),
    );
  }
}
