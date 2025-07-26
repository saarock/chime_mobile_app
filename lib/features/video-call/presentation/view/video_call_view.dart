import 'dart:async'; // Import for Timer

import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/core/common/my_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView>
    with TickerProviderStateMixin {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  bool _remoteUserConnected = false;
  Timer? _noRemoteUserTimer;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _requestPermissionsAndInit();

    _remoteUserConnected = false;
  }

  @override
  void dispose() {
    _noRemoteUserTimer?.cancel();

    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    _pulseController.dispose();

    super.dispose();
  }

  Future<void> _requestPermissionsAndInit() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    final cameraGranted = statuses[Permission.camera]!.isGranted;
    final micGranted = statuses[Permission.microphone]!.isGranted;

    if (cameraGranted && micGranted) {
      await _initRenderers();
      await _initSocketConnection();
      context.read<VideoBloc>().add(LoadLocalStreamEvent());
    } else {
      if (!mounted) return;

      showMySnackBar(
        context: context,
        message: "Camera and microphone permissions are required.",
      );

      if (await Permission.camera.isPermanentlyDenied ||
          await Permission.microphone.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Chime Talk - Video Call",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is VideoLocalStreamLoaded) {
              _localRenderer.srcObject = state.localStream;
              context.read<VideoBloc>().add(
                CreatePeerConnectionEvent(state.localStream),
              );
            }

            if (state is VideoRemoteStreamUpdated) {
              _remoteUserConnected = true;
              _remoteRenderer.srcObject = state.remoteStream;
              _noRemoteUserTimer?.cancel();
            }

            if (state is VideoCallEnded) {
              _remoteUserConnected = false;
              _remoteRenderer.srcObject = null;
              _noRemoteUserTimer?.cancel();
            }
          },
          builder: (context, state) {
            final onlineCount = context.watch<VideoBloc>().onlineUserCount;
            final isCalling =
                state is VideoInCall || state is VideoWaitingForMatch;

            String statusMessage = "";
            if (state is VideoConnecting) {
              statusMessage = "🔄 Connecting to socket...";
            } else if (state is VideoConnected) {
              statusMessage = "✅ Connected to server";
            } else if (state is VideoLocalStreamLoaded) {
              statusMessage = "📷 Camera ready. Waiting...";
            } else if (state is VideoWaitingForMatch) {
              statusMessage = "⌛ Waiting for a match...";
            } else if (state is VideoCallEnded) {
              statusMessage = "📴 Call ended.";
            } else if (state is VideoError) {
              statusMessage = "❌ ${state.message}";
            } else if (state is VideoMicMuted) {
              statusMessage = "🔇 Microphone muted due to proximity";
            } else if (state is VideoMicUnmuted) {
              statusMessage = "🎤 Microphone unmuted";
            } else if (state is VideoCameraSwitched) {
              statusMessage = "📸 Camera switched due to shake";
            } else if (state is VideoLowLightDetected) {
              statusMessage = "💡 Low light detected, please turn on light";
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isSmallWidth = constraints.maxWidth < 400;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status bar and online user count
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallWidth ? 12 : 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              statusMessage,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "👥 Online Users: $onlineCount",
                            style: TextStyle(
                              color: Colors.tealAccent.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main video area
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child:
                                _remoteRenderer.srcObject == null
                                    ? Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallWidth ? 20 : 30,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "✨ Ready to connect with someone?\nTap below to start a random call!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize:
                                                      isSmallWidth ? 18 : 22,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: isSmallWidth ? 24 : 32,
                                            ),
                                            ScaleTransition(
                                              scale: Tween(
                                                begin: 0.9,
                                                end: 1.1,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: _pulseController,
                                                  curve: Curves.easeInOut,
                                                ),
                                              ),
                                              child: ElevatedButton.icon(
                                                onPressed:
                                                    isCalling
                                                        ? null
                                                        : () {
                                                          final loginState =
                                                              context
                                                                  .read<
                                                                    LoginViewModel
                                                                  >()
                                                                  .state;
                                                          final user =
                                                              loginState
                                                                  .userApiModel;

                                                          if (user == null) {
                                                            showMySnackBar(
                                                              context: context,
                                                              message:
                                                                  "Something went wrong. Please logout and login again or try later.",
                                                            );
                                                            return;
                                                          }

                                                          _remoteUserConnected =
                                                              false;
                                                          context
                                                              .read<VideoBloc>()
                                                              .add(
                                                                StartRandomCall(
                                                                  userDetails:
                                                                      user.toJson(),
                                                                ),
                                                              );
                                                        },
                                                icon: const Icon(
                                                  Icons.videocam,
                                                ),
                                                label: Text(
                                                  isCalling
                                                      ? "Calling..."
                                                      : "Start Random Call",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallWidth ? 16 : 18,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      isCalling
                                                          ? Colors.grey.shade700
                                                          : Colors
                                                              .tealAccent
                                                              .shade700,
                                                  foregroundColor: Colors.black,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isSmallWidth ? 28 : 38,
                                                    vertical:
                                                        isSmallWidth ? 12 : 16,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  elevation: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: RTCVideoView(
                                          _remoteRenderer,
                                          objectFit:
                                              RTCVideoViewObjectFit
                                                  .RTCVideoViewObjectFitCover,
                                        ),
                                      ),
                                    ),
                          ),

                          // Local video preview at bottom right
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: Container(
                              width: isSmallWidth ? 110 : 140,
                              height: isSmallWidth ? 140 : 180,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white70,
                                  width: 1.8,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade900.withOpacity(0.7),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: RTCVideoView(
                                    _localRenderer,
                                    mirror: true,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Overlay when waiting or connecting
                          if (state is VideoConnecting ||
                              state is VideoWaitingForMatch)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Colors.tealAccent,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        statusMessage,
                                        style: const TextStyle(
                                          color: Colors.tealAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Bottom buttons for start/end call
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallWidth ? 12 : 24,
                        vertical: isSmallWidth ? 20 : 24,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                isCalling
                                    ? null
                                    : () {
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

                                      _remoteUserConnected = false;

                                      context.read<VideoBloc>().add(
                                        StartRandomCall(
                                          userDetails: user.toJson(),
                                        ),
                                      );
                                    },
                            icon: const Icon(Icons.shuffle),
                            label: Text(
                              "Start Random Call",
                              style: TextStyle(
                                fontSize: isSmallWidth ? 14 : 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isCalling
                                      ? Colors.grey
                                      : Colors.green.shade600,
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallWidth ? 20 : 28,
                                vertical: isSmallWidth ? 12 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 4,
                            ),
                          ),

                          ElevatedButton.icon(
                            onPressed:
                                _remoteUserConnected
                                    ? () {
                                      final partnerId =
                                          context
                                              .read<VideoBloc>()
                                              .currentPartnerId;
                                      if (partnerId == null) {
                                        showMySnackBar(
                                          context: context,
                                          message:
                                              "No active partner to end call.",
                                        );
                                        return;
                                      }

                                      context.read<VideoBloc>().add(
                                        EndCallEvent(partnerId),
                                      );

                                      _remoteUserConnected = false;
                                      _remoteRenderer.srcObject = null;

                                      _noRemoteUserTimer?.cancel();
                                    }
                                    : null,
                            icon: const Icon(Icons.call_end),
                            label: Text(
                              "End Call",
                              style: TextStyle(
                                fontSize: isSmallWidth ? 14 : 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _remoteUserConnected
                                      ? Colors.red.shade700
                                      : Colors.grey,
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallWidth ? 20 : 28,
                                vertical: isSmallWidth ? 12 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
