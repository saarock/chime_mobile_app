import 'package:chime/common/custom_app.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Chat"),
      body: Center(
        child: Text(
          "Chat View",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
