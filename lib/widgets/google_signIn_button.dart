import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:chime/viewmodels/auth_view_model.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Column(
      children: [
        if (authVM.isLoading)
          const CircularProgressIndicator() // Loading indicator while authenticating
        else
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
              shadowColor: Colors.black.withAlpha(1),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            onPressed: () {
              // Trigger sign-in method on ViewModel
              authVM.signInWithGoogle();
            },
          ),
      ],
    );
  }
}
