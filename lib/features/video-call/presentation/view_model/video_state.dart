import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoConnecting extends VideoState {}

class VideoConnected extends VideoState {}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

class VideoWaitingForMatch extends VideoState {}

class VideoLocalStreamLoaded extends VideoState {
  final MediaStream localStream;
  VideoLocalStreamLoaded(this.localStream);
}

class VideoPeerConnectionReady extends VideoState {
  final RTCPeerConnection peerConnection;
  VideoPeerConnectionReady(this.peerConnection);
}

class VideoCallEnded extends VideoState {}

class VideoRemoteStreamUpdated extends VideoState {
  final MediaStream? remoteStream;
  VideoRemoteStreamUpdated(this.remoteStream);
}

class VideoSuccessMessage extends VideoState {
  final String message;
  VideoSuccessMessage(this.message);
}

class VideoPartnerCallEnded extends VideoState {
  final bool isEnded;
  VideoPartnerCallEnded(this.isEnded);
}

class VideoMatchFound extends VideoState {
  final Map<String, dynamic> partnerInfo;
  VideoMatchFound(this.partnerInfo);
}

class VideoInCall extends VideoState {}
