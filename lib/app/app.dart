import 'package:chime/app/theme/my_theme.dart';
import 'package:chime/features/splash/presentation/view/splah_screen_view.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getMyTheme(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => SplashViewModel(),
        child: SplashScreenView(),
      ),
    );
  }
}
