// lib/features/video-call/presentation/bloc/video_cubit.dart

import 'package:chime/features/video-call/presentation/view_model/video_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  void connectToCall() async {
    emit(VideoConnecting());
    await Future.delayed(Duration(seconds: 2)); // simulate connection delay
    emit(VideoConnected());
  }

  void throwError(String message) {
    emit(VideoError(message));
  }

  void reset() {
    emit(VideoInitial());
  }
}
