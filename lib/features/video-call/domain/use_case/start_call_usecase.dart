// import 'package:chime/app/use_case/usercase.dart';
// import 'package:chime/core/error/failure.dart';
// import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
// import 'package:dartz/dartz.dart';

// import 'package:equatable/equatable.dart';

// class CallParams extends Equatable {
//   final String partnerId;

//   const CallParams({required this.partnerId});

//   @override
//   List<Object?> get props => [partnerId];
// }

// class StartCallUseCase implements UserCaseWithParams<void, CallParams> {
//   final IVideoCallRepository _repository;

//   StartCallUseCase({required IVideoCallRepository repository})
//     : _repository = repository;

//   @override
//   Future<Either<Failure, void>> call(CallParams param) async {
//     try {
//       await _repository.randomCall(userDetails);
//       return const Right(null);
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }
// }
