import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/create_peer_connection_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/end_call_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/get_localstream_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_answer_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_ice_candidate_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_offer_usecase.dart';
import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final IVideoCallRepository repository;
  String? _currentPartnerId;
  String? get currentPartnerId => _currentPartnerId;

  final SendOfferUseCase sendOfferUseCase;
  final SendAnswerUseCase sendAnswerUseCase;
  final SendIceCandidateUseCase sendIceCandidateUseCase;
  final EndCallUseCase endCallUseCase;
  final GetLocalStreamUseCase getLocalStreamUseCase;
  final CreatePeerConnectionUseCase createPeerConnectionUseCase;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  VideoBloc({
    required this.repository,
    required this.sendOfferUseCase,
    required this.sendAnswerUseCase,
    required this.sendIceCandidateUseCase,
    required this.endCallUseCase,
    required this.getLocalStreamUseCase,
    required this.createPeerConnectionUseCase,
  }) : super(VideoInitial()) {
    on<ConnectSocket>(_onConnectSocket);
    on<SendOfferEvent>(_onSendOffer);
    on<SendAnswerEvent>(_onSendAnswer);
    on<SendIceCandidateEvent>(_onSendIceCandidate);
    on<EndCallEvent>(_onEndCall);
    on<OfferReceivedEvent>(_onOfferReceived);
    on<AnswerReceivedEvent>(_onAnswerReceived);
    on<IceCandidateReceivedEvent>(_onIceCandidateReceived);
    on<CallEndedEvent>(_onCallEnded);
    on<WaitEvent>(_onWait);
    on<SelfLoopEvent>(_onSelfLoop);
    on<MatchFoundEvent>(_onMatchFound);
    on<LoadLocalStreamEvent>(_onLoadLocalStream);
    on<CreatePeerConnectionEvent>(_onCreatePeerConnection);
    on<StartRandomCall>(_onStartRandomCall);
  }

  Future<void> _onStartRandomCall(
    StartRandomCall event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(VideoWaitingForMatch());
      // Call repository or usecase method to start a random call with userDetails
      repository.startRandomCall(event.userDetails);
      // After that, you might wait for a match event (MatchFoundEvent) triggered by socket listener
    } catch (e) {
      emit(VideoError('Failed to start random call: $e'));
    }
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoConnecting());
    try {
      await repository.initConnection(jwt: event.jwt);

      // Attach socket event listeners to add Bloc events
      repository.onOfferReceived((offer) => add(OfferReceivedEvent(offer)));
      repository.onAnswerReceived((answer) => add(AnswerReceivedEvent(answer)));
      repository.onIceCandidateReceived(
        (candidate) => add(IceCandidateReceivedEvent(candidate)),
      );
      repository.onCallEnded(() => add(CallEndedEvent()));
      repository.onWait((_) => add(WaitEvent()));
      repository.onSelfLoop((_) => add(SelfLoopEvent()));
      repository.onIncomingCall((call) {
        // Optionally handle incoming call event here if needed
      });
      repository.onOfferReceived((offer) => add(OfferReceivedEvent(offer)));

      emit(VideoConnected());
    } catch (e) {
      emit(VideoError('Socket connection failed: $e'));
    }
  }

  void _onSendOffer(SendOfferEvent event, Emitter<VideoState> emit) {
    try {
      sendOfferUseCase.execute(event.offer);
    } catch (e) {
      emit(VideoError('Failed to send offer: $e'));
    }
  }

  void _onSendAnswer(SendAnswerEvent event, Emitter<VideoState> emit) {
    try {
      sendAnswerUseCase.execute(event.answer);
    } catch (e) {
      emit(VideoError('Failed to send answer: $e'));
    }
  }

  void _onSendIceCandidate(
    SendIceCandidateEvent event,
    Emitter<VideoState> emit,
  ) {
    try {
      sendIceCandidateUseCase.execute(event.candidate);
    } catch (e) {
      emit(VideoError('Failed to send ICE candidate: $e'));
    }
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<VideoState> emit) async {
    try {
      endCallUseCase.execute(event.partnerId);
      await _peerConnection?.close();
      _peerConnection = null;
      _localStream?.dispose();
      _localStream = null;
      _remoteStream = null;
      emit(VideoCallEnded());
    } catch (e) {
      emit(VideoError('Failed to end call: $e'));
    }
  }

  Future<void> _onOfferReceived(
    OfferReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      if (_peerConnection == null) {
        emit(VideoError('Peer connection not established.'));
        return;
      }
      final offer = event.offer['offer'];
      final from = event.offer['from'];
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );

      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      repository.sendAnswer({
        'to': from,
        'answer': {'sdp': answer.sdp, 'type': answer.type},
      });
    } catch (e) {
      emit(VideoError('Failed to handle received offer: $e'));
    }
  }

  Future<void> _onAnswerReceived(
    AnswerReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      if (_peerConnection == null) return;
      final answer = event.answer['answer'];
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(answer['sdp'], answer['type']),
      );
    } catch (e) {
      emit(VideoError('Failed to handle received answer: $e'));
    }
  }

  Future<void> _onIceCandidateReceived(
    IceCandidateReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      if (_peerConnection == null) return;

      final candidate = event.candidate['candidate'];

      await _peerConnection!.addCandidate(
        RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ),
      );
    } catch (e) {
      emit(VideoError('Failed to add ICE candidate: $e'));
    }
  }

  void _onCallEnded(CallEndedEvent event, Emitter<VideoState> emit) {
    _peerConnection?.close();
    _peerConnection = null;
    _remoteStream = null;
    _currentPartnerId = null;
    emit(VideoCallEnded());
  }

  void _onWait(WaitEvent event, Emitter<VideoState> emit) {
    emit(VideoWaitingForMatch());
  }

  void _onSelfLoop(SelfLoopEvent event, Emitter<VideoState> emit) {
    emit(VideoError("You are already connected on another device (self-loop)"));
  }

  Future<void> _onMatchFound(
    MatchFoundEvent event,
    Emitter<VideoState> emit,
  ) async {
    final partnerInfo = event.partnerInfo;
    final bool isCaller = partnerInfo['isCaller'] ?? false;
    final String partnerId = partnerInfo['partnerId'] ?? '';

    if (_peerConnection == null) {
      emit(VideoError('Peer connection not ready.'));
      return;
    }

    if (!isCaller) {
      emit(VideoWaitingForMatch());
      return;
    }

    try {
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      repository.sendOffer({
        'to': partnerId,
        'offer': {'sdp': offer.sdp, 'type': offer.type},
      });
      _currentPartnerId = partnerId;
    } catch (e) {
      emit(VideoError('Failed to create or send offer: $e'));
    }
  }

  Future<void> _onLoadLocalStream(
    LoadLocalStreamEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      _localStream = await getLocalStreamUseCase.execute();
      emit(VideoLocalStreamLoaded(_localStream!));
    } catch (e) {
      emit(VideoError('Failed to get local stream: $e'));
    }
  }

  Future<void> _onCreatePeerConnection(
    CreatePeerConnectionEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      _peerConnection = await createPeerConnectionUseCase.execute(
        event.localStream,
      );
      _peerConnection!.onIceCandidate = (candidate) {
        if (candidate != null) {
          repository.sendIceCandidate({
            'candidate': {
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            },
          });
        }
      };
      _peerConnection!.onTrack = (event) {
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams[0];
          emit(VideoRemoteStreamUpdated(_remoteStream));
        }
      };
      emit(VideoPeerConnectionReady(_peerConnection!));
    } catch (e) {
      emit(VideoError('Failed to create peer connection: $e'));
    }
  }
}
