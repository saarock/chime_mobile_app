import 'package:chime/common/custom_app.dart';
import 'package:chime/common/google_signIn_button.dart';
import 'package:chime/views/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Login"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.01),
                Image.asset(
                  "assets/images/logo.png",
                  height: size.height * 0.25,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Text(
                  "Welcome!",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1C1A58),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const GoogleSignInButton(),
                const SizedBox(height: 40),
                // Clickable "Don't have account? Register"
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: "Don't have account? "),
                        TextSpan(
                          text: "Register",
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ...existing code...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
