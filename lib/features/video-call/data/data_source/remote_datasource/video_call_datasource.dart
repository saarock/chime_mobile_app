import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallDataSourceImpl implements IVideoCallDataSource {
  late IO.Socket _socket;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  Future<void> initialize({String? jwt}) async {
    _socket = IO.io(
      'http://10.0.2.2:8000/video',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({if (jwt != null) 'Cookie': 'accessToken=$jwt'})
          .build(),
    );
    _socket.connect();

    _socket.on('connect', (_) => print('Socket connected: ${_socket.id}'));
  }

  @override
  void sendOffer(Map<String, dynamic> offer) {
    _socket.emit('call-user', offer);
  }

  @override
  void sendAnswer(Map<String, dynamic> answer) {
    _socket.emit('call-accepted', answer);
  }

  @override
  void sendIceCandidate(Map<String, dynamic> candidate) {
    _socket.emit('ice-candidate', candidate);
  }

  @override
  void endCall(String partnerId) {
    _socket.emit('end-call', {'partnerId': partnerId});
    _peerConnection?.close();
    _peerConnection = null;
    _localStream?.dispose();
    _localStream = null;
  }

  @override
  void onOfferReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on(
      'receive-call',
      (data) => handler(Map<String, dynamic>.from(data)),
    );
  }

  @override
  void onAnswerReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on(
      'call-accepted',
      (data) => handler(Map<String, dynamic>.from(data)),
    );
  }

  @override
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler) {
    _socket.on(
      'ice-candidate',
      (data) => handler(Map<String, dynamic>.from(data)),
    );
  }

  @override
  void onCallEnded(void Function() handler) {
    _socket.on('user:call-ended', (_) => handler());
  }

  @override
  Future<MediaStream> getLocalStream() async {
    final stream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
    _localStream = stream;
    return stream;
  }

  @override
  Future<RTCPeerConnection> createPeerConnection(
    MediaStream localStream,
  ) async {
    final config = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    final pc = await createPeerConnection(config as MediaStream);

    localStream.getTracks().forEach((track) {
      pc.addTrack(track, localStream);
    });

    _peerConnection = pc;
    return pc;
  }

  @override
  Future<void> dispose() async {
    await _localStream?.dispose();
    _peerConnection?.close();
    _socket.dispose();
  }

  @override
  void startRandomCall(Map<String, dynamic> userDetails) {
    _socket.emit('start-random-call', userDetails);
  }
}
