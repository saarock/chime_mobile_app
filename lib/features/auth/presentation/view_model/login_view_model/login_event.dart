import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToRegisterViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToRegisterViewEvent({required this.context});
}

class NavigateToHomeEvent extends LoginEvent {
  final BuildContext context;
  NavigateToHomeEvent({required this.context});
}

class LoginWithGoogle extends LoginEvent {
  final BuildContext context;
  final String credential;
  final String clientId;

  LoginWithGoogle({
    required this.context,
    required this.credential,
    required this.clientId,
  });
}
