import 'package:chime/features/auth/domain/entity/user_google_entity.dart';

abstract interface class IUserDataSource {
  Future<String> loginUser(GoogleLoginCredential credentials);
}
