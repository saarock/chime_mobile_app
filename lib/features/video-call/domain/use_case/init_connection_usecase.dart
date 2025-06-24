import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';

class InitConnectionUseCase {
  final IVideoCallRepository repository;

  InitConnectionUseCase(this.repository);

  Future<void> execute({String? jwt}) async {
    await repository.initConnection(jwt: jwt);
  }
}
