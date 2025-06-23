import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/core/common/my_snackbar.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
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
    _initSocketConnection();
  }

  Future<void> _initSocketConnection() async {
    final videoBloc = context.read<VideoBloc>();
    final String? accessToken = await CookieCache.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      print("Access token is empty");
      return;
    }

    videoBloc.add(ConnectSocket(jwt: accessToken));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          String message = "🔌 Not connected";
          int onlineUserCount = 0;

          if (state is VideoConnecting) {
            message = "🔄 Connecting to socket...";
          } else if (state is VideoConnected) {
            message = "✅ Connected to video server";
            // onlineUserCount = state.onlineUserCount;
          } else if (state is VideoWaitingForMatch) {
            message = "⌛ Waiting for a match...";
          } else if (state is VideoMatchFound) {
            message = "🎯 Match found!";
          } else if (state is VideoInCall) {
            message = "📞 In call...";
          } else if (state is VideoCallEnded) {
            message = "📴 Call ended.";
          } else if (state is VideoError) {
            message = "❌ Error: ${state.message}";
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text("👥 Online Users: $onlineUserCount"),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  final loginState = context.read<LoginViewModel>().state;
                  final userApiModel = loginState.userApiModel;
                  if (userApiModel == null) {
                    showMySnackBar(
                      context: context,
                      message: "User details are not found",
                    );
                    return;
                  }

                  final userDetails = userApiModel.toJson();
                  context.read<VideoBloc>().add(
                    StartRandomCall(userDetails: userDetails),
                  );
                },
                icon: const Icon(Icons.shuffle),
                label: const Text("Random Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // context.read<VideoBloc>().add(EndCall());
                },
                icon: const Icon(Icons.call_end),
                label: const Text("End Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
