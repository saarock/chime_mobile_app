import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallDataSourceImpl implements IVideoCallDataSource {
  late IO.Socket _socket;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  // Optional: Internal callbacks (if needed by Bloc setup)
  void Function(Map<String, dynamic>)? _onMatchFound;
  void Function(Map<String, dynamic>)? _onOfferReceived;
  void Function(Map<String, dynamic>)? _onAnswerReceived;
  void Function(Map<String, dynamic>)? _onIceCandidateReceived;
  void Function()? _onCallEnded;
  void Function()? _onWait;
  void Function()? _onSelfLoop;
  void Function(String)? _onError;
  void Function(String)? _onSuccess;
  void Function(int)? _onOnlineUsersCount;

  @override
  void initialize({String? jwt}) {
    _socket = IO.io(
      'http://10.0.2.2:8000/video',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Cookie': 'accessToken=$jwt'})
          .build(),
    );

    _socket.connect();
    _socket.on('connect', (_) => print('Socket connected'));

    _socket.on('user:match-found', (data) {
      _onMatchFound?.call(Map<String, dynamic>.from(data));
    });

    _socket.on('receive-call', (data) {
      _onOfferReceived?.call(Map<String, dynamic>.from(data));
    });

    _socket.on('call-accepted', (data) {
      _onAnswerReceived?.call(Map<String, dynamic>.from(data));
    });

    _socket.on('ice-candidate', (data) {
      _onIceCandidateReceived?.call(Map<String, dynamic>.from(data));
    });

    _socket.on('user:call-ended', (_) {
      _onCallEnded?.call();
    });

    _socket.on('user:call-ended:try:for:other', (_) {
      _onCallEnded?.call(); // Optional: separate retry callback if needed
    });

    _socket.on('self-loop', (_) {
      _onSelfLoop?.call();
    });

    _socket.on('wait', (_) {
      print("Ok i am waiting...");
      _onWait?.call();
    });

    _socket.on('user:not-found', (data) {
      _onError?.call(data['message']);
    });

    _socket.on('video:global:error', (data) {
      _onError?.call(data['message']);
    });

    _socket.on('duplicate:connection', (data) {
      _onError?.call(data['message']);
    });

    _socket.on('call-error', (data) {
      _onError?.call(data['message']);
    });

    _socket.on('global:success:message', (data) {
      _onSuccess?.call(data['message']);
    });

    _socket.on('onlineUsersCount', (data) {
      final count = data['count'];
      _onOnlineUsersCount?.call(count is int ? count : 0);
    });
  }

  @override
  void startRandomCall(Map<String, dynamic> userDetails) {
    print("random call started");
    _socket.emit('start:random-video-call', userDetails);
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
    final config = {
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
  void emitGetOnlineUserCount(void Function(int) callback) {
    _socket.emitWithAck(
      'onlineUsersCount',
      null,
      ack: (response) {
        print(response);
        final count =
            response is Map && response['count'] is int
                ? response['count'] as int
                : 0;
        callback(count);
      },
    );
  }

  // Attach event handlers — these get called from the Bloc

  @override
  void onMatchFound(void Function(Map<String, dynamic>) handler) {
    _onMatchFound = handler;
  }

  @override
  void onOfferReceived(void Function(Map<String, dynamic>) handler) {
    _onOfferReceived = handler;
  }

  @override
  void onAnswerReceived(void Function(Map<String, dynamic>) handler) {
    _onAnswerReceived = handler;
  }

  @override
  void onIceCandidateReceived(void Function(Map<String, dynamic>) handler) {
    _onIceCandidateReceived = handler;
  }

  @override
  void onCallEnded(void Function() handler) {
    _onCallEnded = handler;
  }

  @override
  void onWait(void Function() handler) {
    _onWait = handler;
  }

  @override
  void onSelfLoop(void Function() handler) {
    _onSelfLoop = handler;
  }

  @override
  void onError(void Function(String) handler) {
    _onError = handler;
  }

  @override
  void onSuccess(void Function(String) handler) {
    _onSuccess = handler;
  }
}
