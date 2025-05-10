import 'package:chime/views/login_with_google/login_with_google_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SphashScreenView extends StatefulWidget {
  const SphashScreenView({super.key});

  @override
  State<SphashScreenView> createState() => _SphashScreenViewState();
}

class _SphashScreenViewState extends State<SphashScreenView> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginWithGoogleView()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
  }
}
