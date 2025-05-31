import 'package:chime/common/custom_navigation_bar.dart';
import 'package:chime/views/chat/chat_view.dart';
import 'package:chime/views/profile/profile_view.dart';
import 'package:chime/views/video_call/video_call.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  int _selectedIndex = 0;

  final List<Widget> _pages = [ChatView(), VideoCall(), ProfileView()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
