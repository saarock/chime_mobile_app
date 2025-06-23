import 'package:chime/app/constant/socket_endpoints.dart';
import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallDatasource implements IVideoCallDataSource {
  late IO.Socket _socket;

  @override
  Future<void> initialize({String? jwt}) async {
    print("I am running to connect to the socket on node server!!!!!");
    _socket = IO.io(
      'http://10.0.2.2:8000/video', // ← changed from localhost
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            if (jwt != null)
              'cookie': 'accessToken=$jwt', // send cookie manually
          })
          .build(),
    );

    _socket.connect();
    print("socket is connected");

    _socket.onConnect((_) => print('Socket connected ✅'));
    _socket.onDisconnect((_) => print('Socket disconnected ❌'));
    _socket.onConnectError((data) => print('Socket connection error ❗: $data'));
    _socket.onError((data) => print('General socket error ❗: $data'));
  }

  @override
  Future<void> dispose() async {
    _socket.dispose();
  }

  @override
  void joinQueue({required Map<String, dynamic> userDetails}) {
    _socket.emit(SocketEventKeys.call, {'userDetails': userDetails});
  }

  @override
  void leaveQueue() {
    _socket.emit("leave-queue");
  }

  @override
  void sendOffer(Map<String, dynamic> offer) {
    _socket.emit("send-offer", offer);
  }

  @override
  void sendAnswer(Map<String, dynamic> answer) {
    _socket.emit("send-answer", answer);
  }

  @override
  void sendIceCandidate(Map<String, dynamic> candidate) {
    _socket.emit("ice-candidate", candidate);
  }

  @override
  void endCall({required String partnerId}) {
    _socket.emit(SocketEventKeys.callEnded, {"partnerId": partnerId});
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Event Listeners
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void onIncomingCall(void Function(Map<String, dynamic>) handler) {
    _socket.on(SocketEventKeys.receiveCall, (data) {
      if (data is Map<String, dynamic>) handler(data);
    });
  }

  @override
  void onOfferReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on(SocketEventKeys.callAccepted, (data) {
      if (data is Map<String, dynamic>) handler(data);
    });
  }

  @override
  void onAnswerReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on("answer", (data) {
      if (data is Map<String, dynamic>) handler(data);
    });
  }

  @override
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on("ice-candidate", (data) {
      if (data is Map<String, dynamic>) handler(data);
    });
  }

  @override
  void onCallEnded(void Function() handler) {
    _socket.on("user:call-ended", (_) => handler());
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Optional Custom Handlers
  // ─────────────────────────────────────────────────────────────────────────────

  void onWait(void Function(dynamic) handler) => _socket.on("wait", handler);

  void onMatchFound(void Function(dynamic) handler) =>
      _socket.on("user:match-found", handler);

  void onNextTry(void Function(dynamic) handler) =>
      _socket.on("user:call-ended:try:for:other", handler);

  void onSelfLoop(void Function(dynamic) handler) =>
      _socket.on("self-loop", handler);

  void onError(void Function(dynamic) handler) {
    _socket.on("video:global:error", handler);
    _socket.on("duplicate:connection", handler);
    _socket.on("call-error", handler);
  }

  void onSuccessMessage(void Function(dynamic) handler) =>
      _socket.on("global:success:message", handler);
}
