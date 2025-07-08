import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class GetLocalStreamUseCase {
  final IVideoCallRepository repository;

  GetLocalStreamUseCase(this.repository);

  Future<MediaStream> execute() async {
    return await repository.getLocalStream();
  }
}
