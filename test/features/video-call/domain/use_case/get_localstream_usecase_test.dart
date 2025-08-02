import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/get_localstream_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

// Fake MediaStream for fallback value and return value
class FakeMediaStream extends Fake implements MediaStream {}

void main() {
  late GetLocalStreamUseCase useCase;
  late MockVideoCallRepository mockRepository;
  late FakeMediaStream fakeMediaStream;

  setUpAll(() {
    registerFallbackValue(FakeMediaStream());
  });

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = GetLocalStreamUseCase(mockRepository);
    fakeMediaStream = FakeMediaStream();
  });

  test('execute returns MediaStream from repository', () async {
    // Arrange: stub repository method to return the fake MediaStream
    when(
      () => mockRepository.getLocalStream(),
    ).thenAnswer((_) async => fakeMediaStream);

    // Act: call use case execute
    final result = await useCase.execute();

    // Assert: result is the fake MediaStream
    expect(result, equals(fakeMediaStream));

    // Verify repository method called once
    verify(() => mockRepository.getLocalStream()).called(1);
  });
}
