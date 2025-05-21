import 'package:chime/common/custom_app.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Center(
        child: Text(
          "Profile View",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
