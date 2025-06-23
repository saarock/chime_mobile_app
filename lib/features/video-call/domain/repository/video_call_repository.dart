abstract class IVideoCallRepository {
  /// Initializes the socket layer
  Future<void> initConnection({required String userId, String? jwt});

  /// Joins the random call queue
  void randomCall(Map<String, dynamic> userDetails);

  /// Leaves the queue
  void leaveQueue();

  /// Starts a call with a remote peer
  void sendOffer(Map<String, dynamic> offer);

  /// Accepts a call
  void sendAnswer(Map<String, dynamic> answer);

  /// Sends ICE candidate for WebRTC
  void sendIceCandidate(Map<String, dynamic> candidate);

  /// Ends current call
  void endCall(String partnerId);

  /// Listens for signaling events
  void onIncomingCall(void Function(Map<String, dynamic>) handler);
  void onOfferReceived(void Function(Map<String, dynamic>) handler);
  void onAnswerReceived(void Function(Map<String, dynamic>) handler);
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler);
  void onCallEnded(void Function() handler);

  /// Tracks call state
  Future<void> dispose();
  Stream<bool> watchCallStatus();
}
