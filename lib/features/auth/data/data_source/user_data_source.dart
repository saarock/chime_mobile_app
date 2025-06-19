import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/entity/user_google_entity.dart';

abstract interface class IUserDataSource {
  Future<UserApiModel> loginUser(GoogleLoginCredential credentials);
  Future<UserApiModel> verifyUser();
}
