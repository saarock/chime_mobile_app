import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/token_storage.dart';

const String kGoogleServerClientId =
    '919257690124-g5spm7tfifrbpb69unkr6u69n5m8tus5.apps.googleusercontent.com';

class AuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: kGoogleServerClientId,
  );

  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      print("strted loginWith google");
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        return false; // User canceled the sign-in
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        return false; // Token was not returned
      }

      final AuthService authService = AuthService();

      final UserModel user = await authService.loginWithGoogle(
        credentials: idToken,
        clientId: kGoogleServerClientId,
      );

      print('Logged in user: $user');
      _user = user;
      await TokenStorage.saveUser(user); // Also store user locally
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Google Sign-In error**************: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    _user = await TokenStorage.getUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    _user = null;
    await TokenStorage.clear(); // Clear user + tokens
    notifyListeners();
  }
}
