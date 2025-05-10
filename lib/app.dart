import 'package:chime/views/login_with_google/login_with_google_view.dart';
import 'package:chime/views/splash_screen/sphash_screen_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SphashScreenView(),
    );
  }
}
