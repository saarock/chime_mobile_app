import 'package:chime/common/my_snackbar.dart';
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
          const CircularProgressIndicator()
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
            onPressed: () async {
              try {
                bool isSuccess = await authVM.signInWithGoogle();
                if (isSuccess) {
                  if (context.mounted) {
                    showMySnackBar(
                      context: context,
                      message: "Login successful",
                    );
                    // Navigate to home or dashboard if needed
                    // Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                } else {
                  if (context.mounted) {
                    showMySnackBar(
                      context: context,
                      message: "Login cancelled or failed",
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  showMySnackBar(
                    context: context,
                    message: "Something went wrong: ${e.toString()}",
                    color: Colors.red,
                  );
                }
              }
            },
          ),
      ],
    );
  }
}
