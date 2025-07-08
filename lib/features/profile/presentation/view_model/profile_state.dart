import 'package:equatable/equatable.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserApiModel user;

  ProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}
