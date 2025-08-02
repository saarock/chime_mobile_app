import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/end_call_usecase.dart';

// Mock for IVideoCallRepository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

void main() {
  late EndCallUseCase useCase;
  late MockVideoCallRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = EndCallUseCase(mockRepository);
  });

  test('execute calls repository.endCall with given partnerId', () {
    const partnerId = 'partner123';

    // Stub the endCall method to do nothing (optional)
    when(() => mockRepository.endCall(any())).thenReturn(null);

    useCase.execute(partnerId);

    // Verify endCall is called once with partnerId
    verify(() => mockRepository.endCall(partnerId)).called(1);
  });

  test('execute calls repository.endCall with null when partnerId is null', () {
    when(() => mockRepository.endCall(any())).thenReturn(null);

    useCase.execute(null);

    verify(() => mockRepository.endCall(null)).called(1);
  });
}
