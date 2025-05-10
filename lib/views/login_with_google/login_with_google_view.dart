import 'package:chime/widgets/custom_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogleView extends StatelessWidget {
  const LoginWithGoogleView({super.key});

  // Initialize GoogleSignIn
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Login"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 170),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Image.asset("assets/images/logo.png", height: 180),
            const SizedBox(height: 24),
            Text(
              "Welcome!",
              style: GoogleFonts.poppins(
                color: const Color(0xFF1C1A58),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Sign in to continue",
              style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Image.asset('assets/images/google_logo.png', height: 24),
              label: Text(
                'Sign in with Google',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              onPressed: () {
                // TODO: Add sign-in logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
