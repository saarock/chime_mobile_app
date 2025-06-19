import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class NavigateToLoginViewEvent extends RegisterEvent {
  final BuildContext context;

  NavigateToLoginViewEvent({required this.context});
}
