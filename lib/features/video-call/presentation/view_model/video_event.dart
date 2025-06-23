import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class ConnectSocket extends VideoEvent {
  final String? jwt; // only send jwt token, backend will identify user

  const ConnectSocket({this.jwt});

  @override
  List<Object?> get props => [jwt];
}

class DisconnectSocket extends VideoEvent {}

// Add other events like JoinQueue, LeaveQueue, IncomingCallReceived, etc.

class StartRandomCall extends VideoEvent {
  final Map<String, dynamic> userDetails; // user info to join queue

  const StartRandomCall({required this.userDetails});

  @override
  List<Object?> get props => [userDetails];
}
