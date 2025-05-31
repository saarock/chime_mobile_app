import 'package:chime/theme/my_theme.dart';
import 'package:chime/views/splash_screen/splash_screen_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getMyTheme(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreenView(),
    );
  }
}
