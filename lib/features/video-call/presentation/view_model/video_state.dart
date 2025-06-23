import 'package:equatable/equatable.dart';

abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoConnecting extends VideoState {}

class VideoConnected extends VideoState {}

class VideoWaitingForMatch extends VideoState {}

class VideoMatchFound extends VideoState {
  final Map<String, dynamic> partnerInfo;
  VideoMatchFound(this.partnerInfo);

  @override
  List<Object?> get props => [partnerInfo];
}

class VideoInCall extends VideoState {}

class VideoCallEnded extends VideoState {}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);

  @override
  List<Object?> get props => [message];
}
