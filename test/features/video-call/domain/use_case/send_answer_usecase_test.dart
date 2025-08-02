import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/send_answer_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

void main() {
  late SendAnswerUseCase useCase;
  late MockVideoCallRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = SendAnswerUseCase(mockRepository);
  });

  test('execute calls repository.sendAnswer with correct answer map', () {
    final answer = {'type': 'answer', 'sdp': 'some_sdp_value'};

    // Stub repository.sendAnswer - no return, void method
    when(() => mockRepository.sendAnswer(any())).thenReturn(null);

    // Call use case
    useCase.execute(answer);

    // Verify that sendAnswer was called once with the answer map
    verify(() => mockRepository.sendAnswer(answer)).called(1);
  });
}
