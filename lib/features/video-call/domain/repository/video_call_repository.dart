import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class IVideoCallRepository {
  Future<void> initConnection({String? jwt});
  void startRandomCall(Map<String, dynamic> userDetails);
  void sendOffer(Map<String, dynamic> offer);
  void sendAnswer(Map<String, dynamic> answer);
  void sendIceCandidate(Map<String, dynamic> candidate);
  void endCall(String? partnerId);
  Future<MediaStream> getLocalStream();
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream);
  Future<void> dispose();

  // Streams for socket events:
  Stream<Map<String, dynamic>> get offerStream;
  Stream<Map<String, dynamic>> get answerStream;
  Stream<Map<String, dynamic>> get iceCandidateStream;
  Stream<void> get callEndedStream;
  Stream<void> get waitStream;
  Stream<void> get selfLoopStream;
  Stream<Map<String, dynamic>> get matchFoundStream;
  Stream<int> get onlineUserCountStream;
  Future<void> fetchOnlineUserCount();
}
