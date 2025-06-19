import 'package:chime/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/auth/presentation/view/login_view.dart';
import 'register_state.dart'; // You can keep a simple state

class RegsiterViewModel extends Bloc<RegisterEvent, RegisterState> {
  RegsiterViewModel() : super(RegisterInitial()) {
    on<NavigateToLoginViewEvent>(_onNavigateToLoginView);
  }

  void _onNavigateToLoginView(
    NavigateToLoginViewEvent event,
    Emitter<RegisterState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }
}
