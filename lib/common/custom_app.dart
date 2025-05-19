import 'package:flutter/material.dart';

// Cutome appbar widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Pass 'key' directly to the super constructor
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF191833),
      elevation: 5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Set the height of the app bar
}
