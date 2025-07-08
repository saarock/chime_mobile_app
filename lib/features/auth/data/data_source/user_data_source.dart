import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/entity/user_google_entity.dart';

abstract interface class IUserDataSource {
  /// Login user using Google credentials
  Future<UserApiModel> loginUser(GoogleLoginCredential credentials);

  /// Verify if the current user is authenticated
  Future<UserApiModel> verifyUser();

  /// Update user profile with important details
  Future<UserApiModel> updateUserImportantDetails(
    Map<String, dynamic> userDetails,
  );
}
