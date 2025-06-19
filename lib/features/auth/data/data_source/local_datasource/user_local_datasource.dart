import 'package:chime/core/network/hive_service.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';

class UserLocalDatasource {
  Future<void> cacheUser(UserApiModel user) async {
    await HiveService().cacheUser({
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'profileImage': user.profilePicture ?? '',
      'userName': user.userName ?? '',
    });
  }
}
