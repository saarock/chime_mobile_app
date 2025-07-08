import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/use_case/update_user_info.usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUserInfoUseCase updateUserInfoUseCase;

  ProfileBloc({required this.updateUserInfoUseCase}) : super(ProfileInitial()) {
    on<SubmitProfileEvent>(_onSubmitProfile);
  }

  Future<void> _onSubmitProfile(
    SubmitProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await updateUserInfoUseCase.call(
      UpdateUserInfoParams(
        userId: event.userId,
        age: event.age,
        userName: event.userName,
        phoneNumber: event.phoneNumber,
        country: event.country,
        gender: event.gender,
        relationshipStatus: event.relationshipStatus,
      ),
    );

    result.fold(
      (Failure failure) =>
          emit(ProfileFailure(failure.message ?? "Update failed")),
      (UserApiModel user) => emit(ProfileSuccess(user)),
    );
  }
}
