// test/mocks.dart

import 'package:mocktail/mocktail.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:chime/features/profile/presentation/view_model/profile_view_model.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockVideoBloc extends Mock implements VideoBloc {}

class MockProfileBloc extends Mock implements ProfileBloc {}
