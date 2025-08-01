import 'dart:async';

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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final IVideoCallRepository repository;
  String? _currentPartnerId;
  String? get currentPartnerId => _currentPartnerId;
  int _onlineUserCount = 0;
  int get onlineUserCount => _onlineUserCount;

  final SendOfferUseCase sendOfferUseCase;
  final SendAnswerUseCase sendAnswerUseCase;
  final SendIceCandidateUseCase sendIceCandidateUseCase;
  final EndCallUseCase endCallUseCase;
  final GetLocalStreamUseCase getLocalStreamUseCase;
  final CreatePeerConnectionUseCase createPeerConnectionUseCase;
  final SensorService _sensorService;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  // ICE candidates queue to be added only after remote description is set
  final List<RTCIceCandidate> _remoteIceCandidateQueue = [];

  // Subscriptions to socket event streams
  late StreamSubscription _offerSub;
  late StreamSubscription _answerSub;
  late StreamSubscription _iceCandidateSub;
  late StreamSubscription _callEndedSub;
  late StreamSubscription _waitSub;
  late StreamSubscription _selfLoopSub;
  late StreamSubscription _matchFoundSub;
  late StreamSubscription<int> _onlineUserSub;

  VideoBloc({
    required this.repository,
    required this.sendOfferUseCase,
    required this.sendAnswerUseCase,
    required this.sendIceCandidateUseCase,
    required this.endCallUseCase,
    required this.getLocalStreamUseCase,
    required this.createPeerConnectionUseCase,
    required SensorService sensorService,
  }) : _sensorService = sensorService,
       super(VideoInitial()) {
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
    on<MuteMicEvent>(_onMuteMic);
    on<UnmuteMicEvent>(_onUnmuteMic);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<LowLightDetectedEvent>(_onLowLight);
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<ReceiveChatMessageEvent>(_onReceiveChatMessage);

    on<RemoteStreamReceivedEvent>((event, emit) {
      emit(VideoRemoteStreamUpdated(event.remoteStream));
    });

    // Toggle audio and video
    on<ToggleMicEvent>((event, emit) {
      if (state is VideoLocalStreamLoaded) {
        final stream = (state as VideoLocalStreamLoaded).localStream;
        for (var track in stream.getAudioTracks()) {
          track.enabled = !event.mute;
        }
        print('Mic toggled: muted = ${event.mute}');
        emit(event.mute ? VideoMicMuted() : VideoMicUnmuted());
      }
    });
    on<ToggleCameraEnabledEvent>((event, emit) {
      if (state is VideoLocalStreamLoaded) {
        final stream = (state as VideoLocalStreamLoaded).localStream;
        for (var track in stream.getVideoTracks()) {
          track.enabled = event.enabled;
        }
        print('Camera toggled: enabled = ${event.enabled}');
        emit(event.enabled ? VideoCameraEnabled() : VideoCameraDisabled());
      }
    });

    _sensorService.initSensors();

    // Listen to sensor streams
    _sensorService.proximityStream.listen((isNear) {
      add(isNear ? MuteMicEvent() : UnmuteMicEvent());
    });

    _sensorService.lightStream.listen((lux) {
      if (lux < 10) {
        add(LowLightDetectedEvent());
      }
    });

    _sensorService.shakeStream.listen((_) {
      add(SwitchCameraEvent());
    });
  }

  // ######################## SENSORS ###########################
  Future<void> _onMuteMic(MuteMicEvent event, Emitter<VideoState> emit) async {
    try {
      print("Muting mic...");
      _localStream?.getAudioTracks().forEach((track) {
        track.enabled = false;
      });
      emit(VideoMicMuted());
    } catch (e) {
      emit(VideoError("Failed to mute mic: $e"));
    }
  }

  Future<void> _onUnmuteMic(
    UnmuteMicEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      print("Unmuting mic...");
      _localStream?.getAudioTracks().forEach((track) {
        track.enabled = true;
      });
      emit(VideoMicUnmuted());
    } catch (e) {
      emit(VideoError("Failed to unmute mic: $e"));
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      print("Switching camera...");
      final videoTrack = _localStream?.getVideoTracks().first;
      if (videoTrack != null) {
        await Helper.switchCamera(videoTrack);
        emit(VideoCameraSwitched());
      } else {
        print("No video track found to switch.");
      }
    } catch (e) {
      emit(VideoError("Failed to switch camera: $e"));
    }
  }

  void _onLowLight(LowLightDetectedEvent event, Emitter<VideoState> emit) {
    print("Low light detected.");
    emit(VideoLowLightDetected());
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoConnecting());
    try {
      print("Connecting to signaling server...");
      await repository.initConnection(jwt: event.jwt);

      print("Fetching online user count...");
      await repository.fetchOnlineUserCount();

      _answerSub = repository.answerStream.listen((answer) {
        print("Received answer from signaling server: $answer");
        add(AnswerReceivedEvent(answer));
      });

      _iceCandidateSub = repository.iceCandidateStream.listen((candidate) {
        print("Received ICE candidate from signaling server: $candidate");
        add(IceCandidateReceivedEvent(candidate));
      });

      _callEndedSub = repository.callEndedStream.listen((_) {
        print("Call ended event received from signaling server.");
        add(CallEndedEvent());
      });

      _waitSub = repository.waitStream.listen((_) {
        print("Wait event received.");
        add(WaitEvent());
      });

      _selfLoopSub = repository.selfLoopStream.listen((_) {
        print("Self loop detected (already connected on another device).");
        add(SelfLoopEvent());
      });

      _matchFoundSub = repository.matchFoundStream.listen((partnerInfo) {
        print("Match found: $partnerInfo");
        add(MatchFoundEvent(partnerInfo));
      });

      _onlineUserSub = repository.onlineUserCountStream.listen((count) {
        _onlineUserCount = count;
        print('🧑‍🤝‍🧑 Online Users count updated: $count');
      });

      emit(VideoConnected());
      print("Socket connected and event listeners attached.");
    } catch (e) {
      print("Socket connection failed: $e");
      emit(VideoError('Socket connection failed: $e'));
    }
  }

  Future<void> _onStartRandomCall(
    StartRandomCall event,
    Emitter<VideoState> emit,
  ) async {
    try {
      print("Starting random call with user details: ${event.userDetails}");
      emit(VideoWaitingForMatch());
      repository.startRandomCall(event.userDetails);
    } catch (e) {
      print("Failed to start random call: $e");
      emit(VideoError('Failed to start random call: $e'));
    }
  }

  void _onSendOffer(SendOfferEvent event, Emitter<VideoState> emit) {
    try {
      print("Sending offer to signaling server: ${event.offer}");
      sendOfferUseCase.execute(event.offer);
    } catch (e) {
      print("Failed to send offer: $e");
      emit(VideoError('Failed to send offer: $e'));
    }
  }

  void _onSendAnswer(SendAnswerEvent event, Emitter<VideoState> emit) {
    try {
      print("Sending answer to signaling server: ${event.answer}");
      sendAnswerUseCase.execute(event.answer);
    } catch (e) {
      print("Failed to send answer: $e");
      emit(VideoError('Failed to send answer: $e'));
    }
  }

  void _onSendIceCandidate(
    SendIceCandidateEvent event,
    Emitter<VideoState> emit,
  ) {
    try {
      print("Sending ICE candidate to signaling server: ${event.candidate}");
      sendIceCandidateUseCase.execute(event.candidate);
    } catch (e) {
      print("Failed to send ICE candidate: $e");
      emit(VideoError('Failed to send ICE candidate: $e'));
    }
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<VideoState> emit) async {
    try {
      print("Call ending...");
      endCallUseCase.execute(event.partnerId);
      await _disposeCurrentSession();
      emit(VideoCallEnded());
      print("Call ended.");
    } catch (e) {
      print("Failed to end call: $e");
      emit(VideoError('Failed to end call: $e'));
    }
  }

  Future<void> _onOfferReceived(
    OfferReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      final offerMap = event.offer;
      final remoteOffer = offerMap['offer'];
      final from = offerMap['from'];

      print("Offer received from $from: $remoteOffer");

      // Dispose old session before creating new one for incoming call
      await _disposeCurrentSession();

      // Ensure local stream is ready before creating peer connection
      if (_localStream == null) {
        print("Local stream not available, loading...");
        _localStream = await getLocalStreamUseCase.execute();
        emit(VideoLocalStreamLoaded(_localStream!));
      }

      // Create new peer connection
      await _createPeerConnectionIfNeeded(emit);

      // Set remote description (offer) from caller
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(remoteOffer['sdp'], remoteOffer['type']),
      );
      print("Remote description set with offer.");

      // Create and set local answer
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      print("Local description set with answer.");

      // Send answer back to caller
      repository.sendAnswer({
        'to': from,
        'answer': {'sdp': answer.sdp, 'type': answer.type},
      });
      print("Answer sent back to $from.");

      _currentPartnerId = from;

      // Add any queued ICE candidates that arrived before remote desc set
      for (final candidate in _remoteIceCandidateQueue) {
        await _peerConnection!.addCandidate(candidate);
        print("Queued ICE candidate added.");
      }
      _remoteIceCandidateQueue.clear();
    } catch (e) {
      print("Failed to handle received offer: $e");
      emit(VideoError('Failed to handle received offer: $e'));
    }
  }

  Future<void> _onAnswerReceived(
    AnswerReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      if (_peerConnection == null) {
        print("Peer connection not established when answer received.");
        return;
      }

      final answer = event.answer['answer'];
      print("Answer received: $answer");

      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(answer['sdp'], answer['type']),
      );
      print("Remote description set with answer.");

      // Add any queued ICE candidates that arrived before remote desc set
      for (final candidate in _remoteIceCandidateQueue) {
        await _peerConnection!.addCandidate(candidate);
        print("Queued ICE candidate added.");
      }
      _remoteIceCandidateQueue.clear();
    } catch (e) {
      print("Failed to handle received answer: $e");
      emit(VideoError('Failed to handle received answer: $e'));
    }
  }

  Future<void> _onIceCandidateReceived(
    IceCandidateReceivedEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      final candidateMap = event.candidate['candidate'];
      final candidate = RTCIceCandidate(
        candidateMap['candidate'],
        candidateMap['sdpMid'],
        candidateMap['sdpMLineIndex'],
      );

      if (_peerConnection == null) {
        print("Peer connection not established, queuing ICE candidate.");
        _remoteIceCandidateQueue.add(candidate);
        return;
      }

      final remoteDesc = await _peerConnection!.getRemoteDescription();

      // If remote description not set yet, queue the ICE candidate
      if (remoteDesc == null) {
        print("Remote description not set, queuing ICE candidate.");
        _remoteIceCandidateQueue.add(candidate);
        return;
      }

      print("ICE candidate received: ${candidateMap['candidate']}");
      await _peerConnection!.addCandidate(candidate);
      print("ICE candidate added to peer connection.");
    } catch (e) {
      print("Failed to add ICE candidate: $e");
      emit(VideoError('Failed to add ICE candidate: $e'));
    }
  }

  void _onCallEnded(CallEndedEvent event, Emitter<VideoState> emit) async {
    print("Call ended event handled.");
    await _disposeCurrentSession();
    _currentPartnerId = null;
    emit(VideoCallEnded());
  }

  void _onWait(WaitEvent event, Emitter<VideoState> emit) {
    print("Waiting for match...");
    emit(VideoWaitingForMatch());
  }

  void _onSelfLoop(SelfLoopEvent event, Emitter<VideoState> emit) {
    print("Self loop detected.");
    emit(VideoError("You are already connected on another device (self-loop)"));
  }

  void _setupPeerConnectionListeners() {
    if (_peerConnection == null) return;

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        print("New ICE candidate generated: ${candidate.candidate}");
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
      print(
        "Received remote track: ${event.track.kind} 999999999999999999999999999999999999999999999999999999",
      );
      _handleRemoteTrack(event);
    };

    _peerConnection!.onConnectionState = (state) {
      print(
        "Peer connection state: $state 88888888888888888888888888888888888888888888888888888888888",
      );
    };
    _peerConnection!.onIceGatheringState = (RTCIceGatheringState state) {
      print("ICE gathering state: $state");
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
        print("ICE gathering complete.");
        // Optionally notify UI or signaling here that ICE candidates gathering is done
      }
    };

    _peerConnection!.onIceConnectionState = (state) {
      print(
        "ICE connection state: $state 1000101010101010101010100101010101101010101",
      );
    };
  }

  void _handleRemoteTrack(RTCTrackEvent event) {
    MediaStream? remoteStream;

    if (event.streams.isNotEmpty) {
      remoteStream = event.streams.first;

      // ✅ DO NOT manually add track, it’s already managed
      add(RemoteStreamReceivedEvent(remoteStream));
    } else {
      // Rare case: no stream associated with the track
      createLocalMediaStream('remoteStream').then((tempStream) {
        tempStream.addTrack(
          event.track,
        ); // This is sometimes acceptable in fallback mode
        add(RemoteStreamReceivedEvent(tempStream));
      });
    }
  }

  Future<void> _onMatchFound(
    MatchFoundEvent event,
    Emitter<VideoState> emit,
  ) async {
    final partnerInfo = event.partnerInfo;
    final bool isCaller = partnerInfo['isCaller'] ?? false;
    final String partnerId = partnerInfo['partnerId'] ?? '';

    print("Match found with partnerId: $partnerId, isCaller: $isCaller");

    try {
      await _disposeCurrentSession();

      // Ensure local stream is loaded
      if (_localStream == null) {
        print("Local stream not available, loading local stream first...");
        _localStream = await getLocalStreamUseCase.execute();
        emit(VideoLocalStreamLoaded(_localStream!));
      }

      // Create or reuse peer connection
      await _createPeerConnectionIfNeeded(emit);

      // Log DTLS certificate fingerprints for debugging (optional)
      // ...

      _currentPartnerId = partnerId;

      if (!isCaller) {
        print("Not caller, waiting for offer from other peer.");
        emit(VideoWaitingForMatch());
        return;
      }

      // Caller creates offer and sets local description
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      print("Offer created: ${offer.sdp?.substring(0, 100)}...");

      // Extract fingerprint from SDP offer for debug
      final regex = RegExp(
        r'a=fingerprint:sha-256 ([A-F0-9:]+)',
        caseSensitive: false,
      );
      final match = regex.firstMatch(offer.sdp ?? '');
      if (match != null) {
        print("Fingerprint in SDP offer: ${match.group(1)}");
      } else {
        print("No fingerprint found in SDP offer.");
      }

      await _peerConnection!.setLocalDescription(offer);
      print("Local description set with offer.");

      repository.sendOffer({
        'to': partnerId,
        'offer': {'sdp': offer.sdp, 'type': offer.type},
      });
      print("Offer sent to $partnerId.");
    } catch (e) {
      print("Failed to create or send offer: $e");
      emit(VideoError('Failed to create or send offer: $e'));
    }
  }

  Future<void> _onLoadLocalStream(
    LoadLocalStreamEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      print("Loading local media stream...");
      _localStream = await getLocalStreamUseCase.execute();
      print(
        "Local stream loaded with audio tracks: ${_localStream?.getAudioTracks().length}, video tracks: ${_localStream?.getVideoTracks().length}",
      );
      emit(VideoLocalStreamLoaded(_localStream!));
    } catch (e) {
      print("Failed to load local stream: $e");
      emit(VideoError('Failed to load local stream: $e'));
    }
  }

  Future<void> _onCreatePeerConnection(
    CreatePeerConnectionEvent event,
    Emitter<VideoState> emit,
  ) async {
    await _createPeerConnectionIfNeeded(emit);
  }

  // New method to safely create or reuse peer connection
  Future<void> _createPeerConnectionIfNeeded(Emitter<VideoState> emit) async {
    if (_peerConnection != null) {
      print("Peer connection already exists, reusing it.");
      emit(VideoPeerConnectionReady(_peerConnection!));
      return;
    }

    try {
      // Dispose any existing session for safety
      await _disposeCurrentSession();

      if (_localStream == null) {
        print("Local stream not available, loading local stream first...");
        _localStream = await getLocalStreamUseCase.execute();
        emit(VideoLocalStreamLoaded(_localStream!));
      }

      print("Creating new peer connection...");
      _peerConnection = await createPeerConnectionUseCase.execute(
        _localStream!,
      );
      _setupPeerConnectionListeners();
      emit(VideoPeerConnectionReady(_peerConnection!));
    } catch (e) {
      print("Failed to create peer connection: $e");
      emit(VideoError('Failed to create peer connection: $e'));
    }
  }

  Future<void> _disposeCurrentSession() async {
    print("Disposing current session...");
    try {
      if (_peerConnection != null) {
        await _peerConnection!.close();
        await _peerConnection!.dispose();
        _peerConnection = null;
        print("Peer connection disposed.");
      }

      if (_localStream != null) {
        await _localStream!.dispose();
        _localStream = null;
        print("Local stream disposed.");
      }

      if (_remoteStream != null) {
        await _remoteStream!.dispose();
        _remoteStream = null;
        print("Remote stream disposed.");
      }

      _remoteIceCandidateQueue.clear();
    } catch (e) {
      print("Error disposing session: $e");
    }
  }

  // #################### CHAT #############
  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      if (_currentPartnerId == null) {
        emit(VideoError("No active call partner to send message"));
        return;
      }

      print("Sending chat message to $_currentPartnerId: ${event.message}");
      await repository.sendChatMessage(
        toUserId: _currentPartnerId!,
        message: event.message,
      );

      // Optionally emit a state for sent message confirmation
    } catch (e) {
      emit(VideoError("Failed to send chat message: $e"));
    }
  }

  void _onReceiveChatMessage(
    ReceiveChatMessageEvent event,
    Emitter<VideoState> emit,
  ) {
    print("Chat message received from ${event.fromUserId}: ${event.message}");
    emit(ChatMessageReceivedState(event.fromUserId, event.message));
  }

  @override
  Future<void> close() async {
    await _disposeCurrentSession();

    await _answerSub.cancel();
    await _iceCandidateSub.cancel();
    await _callEndedSub.cancel();
    await _waitSub.cancel();
    await _selfLoopSub.cancel();
    await _matchFoundSub.cancel();
    await _onlineUserSub.cancel();

    _sensorService.dispose();

    return super.close();
  }
}
