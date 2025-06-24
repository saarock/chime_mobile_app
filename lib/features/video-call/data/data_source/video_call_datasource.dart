import 'package:flutter_webrtc/flutter_webrtc.dart';

/// `IVideoCallDataSource` defines the contract for video call data operations,
/// such as signaling, queue management, and connection events.
abstract interface class IVideoCallDataSource {
  /// Initializes the socket connection with user metadata and optional auth token.
  Future<void> initialize({String? jwt});

  /// Disconnects and cleans up the socket connection.
  Future<void> dispose();

  /// Sends a request to join the random call queue with user details.
  void randomCall({required Map<String, dynamic> userDetails});

  /// Sends a request to leave the random call queue.
  void leaveQueue();

  /// Sends an SDP offer to the peer via signaling.
  void sendOffer(Map<String, dynamic> offer);

  /// Sends an SDP answer to the peer via signaling.
  void sendAnswer(Map<String, dynamic> answer);

  /// Sends an ICE candidate to the peer.
  void sendIceCandidate(Map<String, dynamic> candidate);

  /// Listens for an incoming call match event.
  void onIncomingCall(void Function(Map<String, dynamic>) handler);

  /// Listens for an SDP offer from the remote peer.
  void onOfferReceived(void Function(Map<String, dynamic>) handler);

  /// Listens for an SDP answer from the remote peer.
  void onAnswerReceived(void Function(Map<String, dynamic>) handler);

  /// Listens for ICE candidates from the remote peer.
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler);

  /// Emits a call end event with partner ID.
  void endCall({required String partnerId});

  /// Listens when the call is ended by the peer.
  void onCallEnded(void Function() handler);

  // Add these two methods here for socket events:
  void onSelfLoop(void Function(dynamic) handler);
  void onWait(void Function(dynamic) handler);

  // Web rtc
  Future<MediaStream> getLocalStream();
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream);
}
