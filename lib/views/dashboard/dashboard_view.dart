import 'package:chime/common/custom_app.dart';
import 'package:chime/utils/token_storage.dart';
import 'package:chime/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await TokenStorage.clear();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "DashBoard"),
      body: Container(
        child: ElevatedButton(onPressed: logout, child: Text("logout")),
      ),
    );
  }
}
