import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class IVideoCallDataSource {
  // ───────────────────────────────────────────────
  // 1) SOCKET INITIALIZATION
  // ───────────────────────────────────────────────
  void initialize({String? jwt});

  // ───────────────────────────────────────────────
  // 2) SIGNALING ACTIONS
  // ───────────────────────────────────────────────
  void startRandomCall(Map<String, dynamic> userDetails);
  void sendOffer(Map<String, dynamic> offer);
  void sendAnswer(Map<String, dynamic> answer);
  void sendIceCandidate(Map<String, dynamic> candidate);
  void endCall(String partnerId);

  // ───────────────────────────────────────────────
  // 3) SOCKET EVENT LISTENERS
  // ───────────────────────────────────────────────
  void onMatchFound(void Function(Map<String, dynamic>) handler);
  void onOfferReceived(void Function(Map<String, dynamic>) handler);
  void onAnswerReceived(void Function(Map<String, dynamic>) handler);
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler);
  void onCallEnded(void Function() handler);
  void onWait(void Function() handler);
  void onSelfLoop(void Function() handler);
  void onError(void Function(String message) handler);
  void onSuccess(void Function(String message) handler);
  void emitGetOnlineUserCount(void Function(int count) callback);

  // ───────────────────────────────────────────────
  // 4) WEBRTC UTILITIES
  // ───────────────────────────────────────────────
  Future<MediaStream> getLocalStream();
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream);

  // ───────────────────────────────────────────────
  // 5) CLEANUP
  // ───────────────────────────────────────────────
  Future<void> dispose();
}
