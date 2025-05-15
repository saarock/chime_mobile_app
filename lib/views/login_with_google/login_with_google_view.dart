import 'package:chime/viewmodels/auth_view_model.dart';
import 'package:chime/common/custom_app.dart';
import 'package:chime/common/google_signIn_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginWithGoogleView extends StatelessWidget {
  const LoginWithGoogleView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

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
            GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
