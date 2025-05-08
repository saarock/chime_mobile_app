import 'package:flutter/material.dart';

// Cutome appbar widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Pass 'key' directly to the super constructor
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

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
      backgroundColor: Colors.blueAccent,
      elevation: 5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Set the height of the app bar
}
