import 'package:chime/core/common/custom_app.dart';
import 'package:chime/core/common/google_signIn_button.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId:
          "919257690124-g5spm7tfifrbpb69unkr6u69n5m8tus5.apps.googleusercontent.com",
    );

    try {
      final account = await googleSignIn.signIn();
      if (account == null) {
        // User canceled sign-in
        return;
      }

      final authentication = await account.authentication;

      final idToken = authentication.idToken; // The credential you want

      if (idToken != null) {
        // Dispatch event with idToken as credential
        // ignore: use_build_context_synchronously
        context.read<LoginViewModel>().add(
          LoginWithGoogle(
            // ignore: use_build_context_synchronously
            context: context,
            clientId:
                "919257690124-g5spm7tfifrbpb69unkr6u69n5m8tus5.apps.googleusercontent.com",
            credential: idToken,
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve Google ID token')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Continue with Google"),
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
                  "Welcome back!",
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
                BlocBuilder<LoginViewModel, LoginState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return GoogleSignInButton(
                        onPressed: () => _handleGoogleSignIn(context),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    context.read<LoginViewModel>().add(
                      NavigateToRegisterViewEvent(context: context),
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
                        const TextSpan(text: "Don't have an account? "),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
