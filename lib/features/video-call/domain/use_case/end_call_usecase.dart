import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';

class EndCallUseCase {
  final IVideoCallRepository repository;

  EndCallUseCase(this.repository);

  void execute(String? partnerId) {
    repository.endCall(partnerId);
  }
}
