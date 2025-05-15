import 'package:chime/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ["email"],
    clientId:
        "919257690124-g5spm7tfifrbpb69unkr6u69n5m8tus5.apps.googleusercontent.com",
  );

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final auth = await account.authentication;
      final String? credentials = auth.idToken;
      final String clientId =
          _googleSignIn.clientId ??
          "919257690124-g5spm7tfifrbpb69unkr6u69n5m8tus5.apps.googleusercontent.com";
      if (credentials == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // run the auth service to make hit the request in the backend
      AuthService authService = AuthService();
      print(" this is the credentials: $credentials");
      print("this is the client id: $clientId");
      await authService.loginWithGoogle(
        credentials: credentials,
        clientId: clientId,
      );
    } catch (error) {
      print('Google Sign-In error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
