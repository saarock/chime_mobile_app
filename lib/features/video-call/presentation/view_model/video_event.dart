import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class VideoEvent {}

class ConnectSocket extends VideoEvent {
  final String? jwt;
  ConnectSocket(this.jwt);
}

class SendOfferEvent extends VideoEvent {
  final Map<String, dynamic> offer;
  SendOfferEvent(this.offer);
}

class SendAnswerEvent extends VideoEvent {
  final Map<String, dynamic> answer;
  SendAnswerEvent(this.answer);
}

class SendIceCandidateEvent extends VideoEvent {
  final Map<String, dynamic> candidate;
  SendIceCandidateEvent(this.candidate);
}

class EndCallEvent extends VideoEvent {
  final String? partnerId;
  EndCallEvent(this.partnerId);
}

class OfferReceivedEvent extends VideoEvent {
  final Map<String, dynamic> offer;
  OfferReceivedEvent(this.offer);
}

class AnswerReceivedEvent extends VideoEvent {
  final Map<String, dynamic> answer;
  AnswerReceivedEvent(this.answer);
}

class IceCandidateReceivedEvent extends VideoEvent {
  final Map<String, dynamic> candidate;
  IceCandidateReceivedEvent(this.candidate);
}

class CallEndedEvent extends VideoEvent {}

class WaitEvent extends VideoEvent {}

class SelfLoopEvent extends VideoEvent {}

class MatchFoundEvent extends VideoEvent {
  final Map<String, dynamic> partnerInfo;
  MatchFoundEvent(this.partnerInfo);
}

class LoadLocalStreamEvent extends VideoEvent {}

class CreatePeerConnectionEvent extends VideoEvent {
  final MediaStream localStream;
  CreatePeerConnectionEvent(this.localStream);
}

class StartRandomCall extends VideoEvent {
  final Map<String, dynamic> userDetails;
  StartRandomCall({required this.userDetails});
}

class InCallEvent extends VideoEvent {}

class MuteMicEvent extends VideoEvent {}

class UnmuteMicEvent extends VideoEvent {}

class SwitchCameraEvent extends VideoEvent {}

class LowLightDetectedEvent extends VideoEvent {}

// Toggle audio and video
class ToggleMicEvent extends VideoEvent {
  final bool mute;
  ToggleMicEvent({required this.mute});
}

class ToggleCameraEnabledEvent extends VideoEvent {
  final bool enabled;
  ToggleCameraEnabledEvent({required this.enabled});
}

class RemoteStreamReceivedEvent extends VideoEvent {
  final MediaStream remoteStream;
  RemoteStreamReceivedEvent(this.remoteStream);
}

// Event to send chat message
class SendChatMessageEvent extends VideoEvent {
  final String message;
  SendChatMessageEvent(this.message);
}

// Event when chat message is received
class ReceiveChatMessageEvent extends VideoEvent {
  final String fromUserId;
  final String message;
  ReceiveChatMessageEvent({required this.fromUserId, required this.message});
}
