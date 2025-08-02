import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/send_offer_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

void main() {
  late SendOfferUseCase useCase;
  late MockVideoCallRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = SendOfferUseCase(mockRepository);
  });

  test('execute calls repository.sendOffer with correct offer map', () {
    final offer = {'type': 'offer', 'sdp': 'fake_sdp'};

    when(() => mockRepository.sendOffer(any())).thenReturn(null);

    useCase.execute(offer);

    verify(() => mockRepository.sendOffer(offer)).called(1);
  });
}
