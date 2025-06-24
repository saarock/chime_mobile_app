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
  final String partnerId;
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
  final dynamic localStream;
  CreatePeerConnectionEvent(this.localStream);
}

class StartRandomCall extends VideoEvent {
  final Map<String, dynamic> userDetails;
  StartRandomCall({required this.userDetails});
}

class InCallEvent extends VideoEvent {}
