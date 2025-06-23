import 'package:chime/core/utils/notification_service.dart';
import 'package:chime/features/video-call/domain/use_case/connect_socket_usecase.dart';
import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final IVideoCallDataSource _videoCallDataSource;

  VideoBloc(this._videoCallDataSource) : super(VideoInitial()) {
    // Public Events
    on<ConnectSocket>(_onConnectSocket);
    on<StartRandomCall>(_onStartRandomCall);

    // Internal socket Events
    on<_SelfLoopEvent>(_handleSelfLoopEvent);
    on<_WaitEvent>(_handleWaitEvent);
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoConnecting());
    try {
      final useCase = ConnectSocketUseCase(_videoCallDataSource);
      await useCase.execute(jwt: event.jwt);
      emit(VideoConnected());

      // Attach socket listeners
      _videoCallDataSource.onSelfLoop((_) => add(_SelfLoopEvent()));
      _videoCallDataSource.onWait((_) => add(_WaitEvent()));
    } catch (e) {
      emit(VideoError('Socket connection failed: $e'));
    }
  }

  Future<void> _onStartRandomCall(
    StartRandomCall event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(VideoWaitingForMatch());
      _videoCallDataSource.startRandomCall(userDetails: event.userDetails);
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  // Notification events call
  Future<void> _handleSelfLoopEvent(
    _SelfLoopEvent event,
    Emitter<VideoState> emit,
  ) async {
    NotificationService.showNotification(
      title: "Connection Error",
      body: "You are already connected on another device (self-loop)",
    );
    emit(VideoError("You cannot connect twice (self-loop)"));
  }

  Future<void> _handleWaitEvent(
    _WaitEvent event,
    Emitter<VideoState> emit,
  ) async {
    NotificationService.showNotification(
      title: "Searching...",
      body: "Please wait while we match you with a random partner.",
    );
    emit(VideoWaitingForMatch());
  }
}

// Internal Events
class _SelfLoopEvent extends VideoEvent {}

class _WaitEvent extends VideoEvent {}
