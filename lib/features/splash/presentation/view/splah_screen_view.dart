import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Call the ViewModel and load Login View after 2 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().init(context);
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  "Welcome to",
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 28, 26, 88),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                child: Image.asset("assets/images/logo.png", height: 140),
              ),
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text('version : beta 1.0.0'),
            ],
          ),
        ),
      ),
    );
  }
}
