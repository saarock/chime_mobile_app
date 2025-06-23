import 'package:chime/features/video-call/presentation/view_model/video_event.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final IVideoCallDataSource _videoCallDataSource;

  VideoBloc(this._videoCallDataSource) : super(VideoInitial()) {
    on<ConnectSocket>(_onConnectSocket);
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoConnecting());
    try {
      await _videoCallDataSource.initialize(jwt: event.jwt);

      emit(VideoConnected());
    } catch (e) {
      emit(VideoError('Socket connection failed: $e'));
    }
  }

  // Add other event handlers (JoinQueue, LeaveQueue, etc.) here
}
