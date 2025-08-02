import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/send_ice_candidate_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

void main() {
  late SendIceCandidateUseCase useCase;
  late MockVideoCallRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = SendIceCandidateUseCase(mockRepository);
  });

  test(
    'execute calls repository.sendIceCandidate with correct candidate map',
    () {
      final candidate = {
        'candidate': 'candidate_value',
        'sdpMid': 'mid',
        'sdpMLineIndex': 0,
      };

      // Stub repository.sendIceCandidate (void method)
      when(() => mockRepository.sendIceCandidate(any())).thenReturn(null);

      // Call use case
      useCase.execute(candidate);

      // Verify repository method called with candidate map
      verify(() => mockRepository.sendIceCandidate(candidate)).called(1);
    },
  );
}
