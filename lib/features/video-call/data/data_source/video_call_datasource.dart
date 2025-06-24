import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class IVideoCallDataSource {
  void startRandomCall(Map<String, dynamic> userDetails);
  Future<void> initialize({String? jwt});
  void sendOffer(Map<String, dynamic> offer);
  void sendAnswer(Map<String, dynamic> answer);
  void sendIceCandidate(Map<String, dynamic> candidate);
  void endCall(String partnerId);

  // Socket listeners registration
  void onOfferReceived(void Function(Map<String, dynamic>) handler);
  void onAnswerReceived(void Function(Map<String, dynamic>) handler);
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler);
  void onCallEnded(void Function() handler);

  // Local WebRTC utilities
  Future<MediaStream> getLocalStream();
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream);
  Future<void> dispose();
}
