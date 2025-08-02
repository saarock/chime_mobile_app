import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/create_peer_connection_usecase.dart';

// Mock repository
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

// Fake MediaStream
class FakeMediaStream extends Fake implements MediaStream {}

// Fake RTCPeerConnection
class FakeRTCPeerConnection extends Fake implements RTCPeerConnection {}

void main() {
  late CreatePeerConnectionUseCase useCase;
  late MockVideoCallRepository mockRepository;
  late FakeMediaStream fakeLocalStream;
  late FakeRTCPeerConnection fakePeerConnection;

  setUpAll(() {
    registerFallbackValue(FakeMediaStream());
  });

  setUp(() {
    mockRepository = MockVideoCallRepository();
    useCase = CreatePeerConnectionUseCase(mockRepository);
    fakeLocalStream = FakeMediaStream();
    fakePeerConnection = FakeRTCPeerConnection();
  });

  test('execute returns RTCPeerConnection from repository', () async {
    // Stub the repository method
    when(
      () => mockRepository.createPeerConnection(fakeLocalStream),
    ).thenAnswer((_) async => fakePeerConnection);

    // Call the use case
    final result = await useCase.execute(fakeLocalStream);

    // Assert the returned connection is the mocked one
    expect(result, equals(fakePeerConnection));

    // Verify the repository method was called once
    verify(
      () => mockRepository.createPeerConnection(fakeLocalStream),
    ).called(1);
  });
}
