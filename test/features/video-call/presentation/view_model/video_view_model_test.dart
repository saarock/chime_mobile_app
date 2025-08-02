import 'package:bloc_test/bloc_test.dart';
import 'package:chime/features/video-call/data/sensors/sensor_service.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/create_peer_connection_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/end_call_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/get_localstream_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_answer_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_ice_candidate_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_offer_usecase.dart';
import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late VideoBloc bloc;
  late MockVideoCallRepository mockRepository;
  late MockSendOfferUseCase mockSendOffer;
  late MockSendAnswerUseCase mockSendAnswer;
  late MockSendIceCandidateUseCase mockSendIce;
  late MockEndCallUseCase mockEndCall;
  late MockGetLocalStreamUseCase mockGetLocalStream;
  late MockCreatePeerConnectionUseCase mockCreatePeer;
  late MockSensorService mockSensors;

  setUp(() {
    mockRepository = MockVideoCallRepository();
    mockSendOffer = MockSendOfferUseCase();
    mockSendAnswer = MockSendAnswerUseCase();
    mockSendIce = MockSendIceCandidateUseCase();
    mockEndCall = MockEndCallUseCase();
    mockGetLocalStream = MockGetLocalStreamUseCase();
    mockCreatePeer = MockCreatePeerConnectionUseCase();
    mockSensors = MockSensorService();

    // Default sensor streams
    when(() => mockSensors.initSensors()).thenReturn(null);
    when(
      () => mockSensors.proximityStream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockSensors.lightStream).thenAnswer((_) => const Stream.empty());
    when(() => mockSensors.shakeStream).thenAnswer((_) => const Stream.empty());

    bloc = VideoBloc(
      repository: mockRepository,
      sendOfferUseCase: mockSendOffer,
      sendAnswerUseCase: mockSendAnswer,
      sendIceCandidateUseCase: mockSendIce,
      endCallUseCase: mockEndCall,
      getLocalStreamUseCase: mockGetLocalStream,
      createPeerConnectionUseCase: mockCreatePeer,
      sensorService: mockSensors,
    );
  });

  blocTest<VideoBloc, VideoState>(
    'emits [VideoMicMuted] when MuteMicEvent is added',
    build: () {
      final stream = MockMediaStream();
      final track = MockMediaStreamTrack();

      when(() => track.enabled).thenReturn(true);
      when(() => stream.getAudioTracks()).thenReturn([track]);

      bloc.emit(VideoLocalStreamLoaded(stream));
      return bloc;
    },
    act: (bloc) => bloc.add(MuteMicEvent()),
    expect: () => [isA<VideoMicMuted>()],
  );

  blocTest<VideoBloc, VideoState>(
    'emits [VideoMicUnmuted] when UnmuteMicEvent is added',
    build: () {
      final stream = MockMediaStream();
      final track = MockMediaStreamTrack();

      when(() => track.enabled).thenReturn(false);
      when(() => stream.getAudioTracks()).thenReturn([track]);

      bloc.emit(VideoLocalStreamLoaded(stream));
      return bloc;
    },
    act: (bloc) => bloc.add(UnmuteMicEvent()),
    expect: () => [isA<VideoMicUnmuted>()],
  );

  blocTest<VideoBloc, VideoState>(
    'emits [VideoLowLightDetected] when LowLightDetectedEvent is added',
    build: () => bloc,
    act: (bloc) => bloc.add(LowLightDetectedEvent()),
    expect: () => [isA<VideoLowLightDetected>()],
  );

  blocTest<VideoBloc, VideoState>(
    'emits [ChatMessageReceivedState] when ReceiveChatMessageEvent is added',
    build: () => bloc,
    act:
        (bloc) => bloc.add(
          ReceiveChatMessageEvent(fromUserId: 'abc', message: 'Hello!'),
        ),
    expect:
        () => [
          isA<ChatMessageReceivedState>()
            ..having((s) => s.fromUserId, 'fromUserId', 'abc')
            ..having((s) => s.message, 'message', 'Hello!'),
        ],
  );
}

/// Mocks
class MockVideoCallRepository extends Mock implements IVideoCallRepository {}

class MockSendOfferUseCase extends Mock implements SendOfferUseCase {}

class MockSendAnswerUseCase extends Mock implements SendAnswerUseCase {}

class MockSendIceCandidateUseCase extends Mock
    implements SendIceCandidateUseCase {}

class MockEndCallUseCase extends Mock implements EndCallUseCase {}

class MockGetLocalStreamUseCase extends Mock implements GetLocalStreamUseCase {}

class MockCreatePeerConnectionUseCase extends Mock
    implements CreatePeerConnectionUseCase {}

class MockSensorService extends Mock implements SensorService {}

class MockMediaStream extends Mock implements MediaStream {}

class MockMediaStreamTrack extends Mock implements MediaStreamTrack {}
