import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';

class SendAnswerUseCase {
  final IVideoCallRepository repository;

  SendAnswerUseCase(this.repository);

  void execute(Map<String, dynamic> answer) {
    repository.sendAnswer(answer);
  }
}
