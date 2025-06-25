import 'dart:async';

import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class IVideoCallRepository {
  Future<void> initConnection({String? jwt});
  void startRandomCall(Map<String, dynamic> userDetails);
  void sendOffer(Map<String, dynamic> offer);
  void sendAnswer(Map<String, dynamic> answer);
  void sendIceCandidate(Map<String, dynamic> candidate);
  void endCall(String partnerId);
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

class VideoCallRepositoryImpl implements IVideoCallRepository {
  final IVideoCallDataSource dataSource;
  final _onlineUserCountController = StreamController<int>.broadcast();

  // StreamControllers to broadcast socket events
  final _offerController = StreamController<Map<String, dynamic>>.broadcast();
  final _answerController = StreamController<Map<String, dynamic>>.broadcast();
  final _iceCandidateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callEndedController = StreamController<void>.broadcast();
  final _waitController = StreamController<void>.broadcast();
  final _selfLoopController = StreamController<void>.broadcast();
  final _matchFoundController =
      StreamController<Map<String, dynamic>>.broadcast();

  VideoCallRepositoryImpl(this.dataSource);

  @override
  Future<void> initConnection({String? jwt}) async {
    dataSource.initialize(jwt: jwt);

    dataSource.onOfferReceived((offer) => _offerController.add(offer));
    dataSource.onAnswerReceived((answer) => _answerController.add(answer));
    dataSource.onIceCandidateReceived(
      (candidate) => _iceCandidateController.add(candidate),
    );
    dataSource.onCallEnded(() => _callEndedController.add(null));
    dataSource.onWait(() => _waitController.add(null));
    dataSource.onSelfLoop(() => _selfLoopController.add(null));
    dataSource.onMatchFound(
      (partnerInfo) => _matchFoundController.add(partnerInfo),
    );

    dataSource.onUserCount((count) => _onlineUserCountController.add(count));
  }

  @override
  void startRandomCall(Map<String, dynamic> userDetails) {
    dataSource.startRandomCall(userDetails);
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
  Future<void> fetchOnlineUserCount() async {
    dataSource.emitGetOnlineUserCount((count) {
      _onlineUserCountController.add(count);
    });
  }

  @override
  Future<MediaStream> getLocalStream() => dataSource.getLocalStream();

  @override
  Future<RTCPeerConnection> createPeerConnection(MediaStream localStream) =>
      dataSource.createPeerConnection(localStream);

  @override
  Future<void> dispose() async {
    await dataSource.dispose();

    await _offerController.close();
    await _answerController.close();
    await _iceCandidateController.close();
    await _callEndedController.close();
    await _waitController.close();
    await _selfLoopController.close();
    await _matchFoundController.close();
    await _onlineUserCountController.close();
  }

  // Expose streams to Bloc

  @override
  Stream<Map<String, dynamic>> get offerStream => _offerController.stream;

  @override
  Stream<Map<String, dynamic>> get answerStream => _answerController.stream;

  @override
  Stream<Map<String, dynamic>> get iceCandidateStream =>
      _iceCandidateController.stream;

  @override
  Stream<void> get callEndedStream => _callEndedController.stream;

  @override
  Stream<void> get waitStream => _waitController.stream;

  @override
  Stream<void> get selfLoopStream => _selfLoopController.stream;

  @override
  Stream<Map<String, dynamic>> get matchFoundStream =>
      _matchFoundController.stream;

  @override
  Stream<int> get onlineUserCountStream => _onlineUserCountController.stream;
}
