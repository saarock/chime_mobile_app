import 'package:chime/features/video-call/data/data_source/remote_datasource/video_call_datasource.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class IVideoCallRepository {
  // ─────────────────────────────────────────────────────────────────────────────
  // Socket initialization
  Future<void> initConnection({String? jwt});
  void startRandomCall(Map<String, dynamic> userDetails);

  // ─────────────────────────────────────────────────────────────────────────────
  // Signaling: sending
  void sendOffer(Map<String, dynamic> offer);
  void sendAnswer(Map<String, dynamic> answer);
  void sendIceCandidate(Map<String, dynamic> candidate);
  void endCall(String partnerId);

  // ─────────────────────────────────────────────────────────────────────────────
  // Signaling: receiving
  void onOfferReceived(void Function(Map<String, dynamic>) handler);
  void onAnswerReceived(void Function(Map<String, dynamic>) handler);
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler);
  void onCallEnded(void Function() handler);

  // ────── 🔴 NEW HANDLERS ──────
  void onWait(void Function(dynamic) handler);
  void onSelfLoop(void Function(dynamic) handler);
  void onIncomingCall(void Function(Map<String, dynamic>) handler);

  // ─────────────────────────────────────────────────────────────────────────────
  // WebRTC
  Future<MediaStream> getLocalStream();
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream);
  Future<void> dispose();
}

class VideoCallRepositoryImpl implements IVideoCallRepository {
  final IVideoCallDataSource dataSource;

  VideoCallRepositoryImpl(this.dataSource);

  @override
  Future<void> initConnection({String? jwt}) async {
    await dataSource.initialize(jwt: jwt);
  }

  @override
  void sendOffer(Map<String, dynamic> offer) {
    dataSource.sendOffer(offer);
  }

  @override
  void sendAnswer(Map<String, dynamic> answer) {
    dataSource.sendAnswer(answer);
  }

  @override
  void sendIceCandidate(Map<String, dynamic> candidate) {
    dataSource.sendIceCandidate(candidate);
  }

  @override
  void endCall(String partnerId) {
    dataSource.endCall(partnerId);
  }

  @override
  void onOfferReceived(void Function(Map<String, dynamic>) handler) {
    dataSource.onOfferReceived(handler);
  }

  @override
  void onAnswerReceived(void Function(Map<String, dynamic>) handler) {
    dataSource.onAnswerReceived(handler);
  }

  @override
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler) {
    dataSource.onIceCandidateReceived(handler);
  }

  @override
  void onCallEnded(void Function() handler) {
    dataSource.onCallEnded(handler);
  }

  @override
  Future<MediaStream> getLocalStream() => dataSource.getLocalStream();

  @override
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream) =>
      dataSource.createPeerConnection(localStream);

  @override
  Future<void> dispose() => dataSource.dispose();

  @override
  void onIncomingCall(void Function(Map<String, dynamic> p1) handler) {
    // TODO: implement onIncomingCall
  }

  @override
  void onSelfLoop(void Function(dynamic p1) handler) {
    // TODO: implement onSelfLoop
  }

  @override
  void onWait(void Function(dynamic p1) handler) {
    // TODO: implement onWait
  }

  @override
  void startRandomCall(Map<String, dynamic> userDetails) {
    dataSource.startRandomCall(userDetails);
  }
}
