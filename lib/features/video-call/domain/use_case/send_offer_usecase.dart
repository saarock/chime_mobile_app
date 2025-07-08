import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';

class SendOfferUseCase {
  final IVideoCallRepository repository;

  SendOfferUseCase(this.repository);

  void execute(Map<String, dynamic> offer) {
    repository.sendOffer(offer);
  }
}
