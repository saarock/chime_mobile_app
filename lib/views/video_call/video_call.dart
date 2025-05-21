import 'package:chime/common/custom_app.dart';
import 'package:flutter/material.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Video Call"),
      body: Center(
        child: Text(
          "Video Call View",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
