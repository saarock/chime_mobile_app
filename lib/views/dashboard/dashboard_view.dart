import 'package:chime/common/custom_app.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Chat")),
    Center(child: Text("Video Call")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Chats"),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFF191833),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            final isSelected = _currentIndex == index;
            final icons = [Icons.chat, Icons.video_call, Icons.person];
            final labels = ["Chat", "Video Call", "Profile"];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                child: Container(
                  height: 77,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color.fromARGB(80, 20, 255, 239)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        color:
                            isSelected
                                ? const Color.fromARGB(255, 20, 255, 239)
                                : Colors.grey,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color:
                              isSelected
                                  ? const Color.fromARGB(255, 20, 255, 239)
                                  : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
