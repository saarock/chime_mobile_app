import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';

class SendIceCandidateUseCase {
  final IVideoCallRepository repository;

  SendIceCandidateUseCase(this.repository);

  void execute(Map<String, dynamic> candidate) {
    repository.sendIceCandidate(candidate);
  }
}
