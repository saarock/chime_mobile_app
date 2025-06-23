import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  @override
  void initState() {
    super.initState();
    _initSocketConnection(); // call async method
  }

  Future<void> _initSocketConnection() async {
    final videoBloc = context.read<VideoBloc>();
    final String? accessToken = await CookieCache.getAccessToken();

    print("Access Token: $accessToken");

    if (accessToken == null || accessToken.isEmpty) {
      print("Access token is empty");
      return;
    }

    videoBloc.add(
      ConnectSocket(jwt: accessToken), // ✅ Remove `const`
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoConnecting) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoConnected) {
            return const Center(
              child: Text("✅ Connected to video call socket"),
            );
          } else if (state is VideoError) {
            return Center(child: Text("❌ Error: ${state.message}"));
          } else {
            return const Center(child: Text("🔌 Not connected yet."));
          }
        },
      ),
    );
  }
}
