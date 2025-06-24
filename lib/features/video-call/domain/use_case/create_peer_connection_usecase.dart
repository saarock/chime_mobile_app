import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CreatePeerConnectionUseCase {
  final IVideoCallRepository repository;

  CreatePeerConnectionUseCase(this.repository);

  Future<RTCPeerConnection> execute(MediaStream localStream) async {
    return await repository.createPeerConnection(localStream);
  }
}
