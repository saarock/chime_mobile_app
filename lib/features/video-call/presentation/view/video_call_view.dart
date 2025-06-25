import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/core/common/my_snackbar.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _initSocketConnection();
    context.read<VideoBloc>().add(LoadLocalStreamEvent());
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _initSocketConnection() async {
    final videoBloc = context.read<VideoBloc>();
    final String? accessToken = await CookieCache.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      print("Access token is empty");
      return;
    }

    videoBloc.add(ConnectSocket(accessToken));
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is VideoLocalStreamLoaded) {
              _localRenderer.srcObject = state.localStream;
              context.read<VideoBloc>().add(
                CreatePeerConnectionEvent(state.localStream),
              );
            }
            if (state is VideoRemoteStreamUpdated) {
              _remoteRenderer.srcObject = state.remoteStream;
            }
          },
          builder: (context, state) {
            final onlineCount = context.watch<VideoBloc>().onlineUserCount;

            String statusMessage = "🔌 Not connected";
            if (state is VideoConnecting) {
              statusMessage = "🔄 Connecting to socket...";
            } else if (state is VideoConnected) {
              statusMessage = "✅ Connected to server";
            } else if (state is VideoWaitingForMatch) {
              statusMessage = "⌛ Waiting for a match...";
            } else if (state is VideoMatchFound) {
              statusMessage = "🎯 Match found!";
            } else if (state is VideoInCall) {
              statusMessage = "📞 In call...";
            } else if (state is VideoCallEnded) {
              statusMessage = "📴 Call ended.";
            } else if (state is VideoError) {
              statusMessage = "❌ ${state.message}";
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusMessage,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "👥 Online Users: $onlineCount",
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child:
                            _remoteRenderer.srcObject == null
                                ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24.0,
                                        ),
                                        child: Text(
                                          "✨ Ready to connect with someone?\nTap below to start a random call!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          final loginState =
                                              context
                                                  .read<LoginViewModel>()
                                                  .state;
                                          final user = loginState.userApiModel;
                                          if (user == null) {
                                            return showMySnackBar(
                                              context: context,
                                              message: "User not found",
                                            );
                                          }
                                          context.read<VideoBloc>().add(
                                            StartRandomCall(
                                              userDetails: user.toJson(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.videocam),
                                        label: const Text("Start Random Call"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.tealAccent.shade700,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 14,
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : RTCVideoView(
                                  _remoteRenderer,
                                  objectFit:
                                      RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitCover,
                                ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.grey.shade800,
                          ),
                          child: RTCVideoView(_localRenderer, mirror: true),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          final loginState =
                              context.read<LoginViewModel>().state;
                          final user = loginState.userApiModel;
                          if (user == null) {
                            showMySnackBar(
                              context: context,
                              message: "User details not found",
                            );
                            return;
                          }
                          context.read<VideoBloc>().add(
                            StartRandomCall(userDetails: user.toJson()),
                          );
                        },
                        icon: const Icon(Icons.shuffle),
                        label: const Text("Start Random Call"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          final partnerId =
                              context.read<VideoBloc>().currentPartnerId;
                          if (partnerId == null) {
                            showMySnackBar(
                              context: context,
                              message: "No active partner to end call.",
                            );
                            return;
                          }
                          context.read<VideoBloc>().add(
                            EndCallEvent(partnerId),
                          );
                        },
                        icon: const Icon(Icons.call_end),
                        label: const Text("End Call"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
