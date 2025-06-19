// lib/features/video-call/presentation/bloc/video_state.dart

abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoConnecting extends VideoState {}

class VideoConnected extends VideoState {}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}
