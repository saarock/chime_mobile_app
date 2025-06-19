import 'package:chime/app/constant/api_endpoints.dart';
import 'package:chime/core/network/api_service.dart';
import 'package:chime/features/auth/data/data_source/user_data_source.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/entity/user_google_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserApiModel> loginUser(GoogleLoginCredential credentals) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {
          "clietnId": credentals.clientId,
          "credential": credentals.credential,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        // Extract userData nested inside data
        final userJson = data['data']['userData'];
        final user = UserApiModel.fromJson(userJson);
        return user;
      } else {
        throw Exception("Failed to login");
      }
    } catch (error) {
      throw Exception("Failed to login student: $error");
    }
  }

  @override
  Future<UserApiModel> verifyUser() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.verifyUser);
      if (response.statusCode == 200) {
        final data = response.data;
        // Extract userData
        final userJson = data['data']['userData'];
        final String accessToken = data['data']['accessToken'];
        // CookieCache.saveAccessToken(accessToken);
        print("Hello AAYUSH This is the acess token");
        print(accessToken);
        return UserApiModel.fromJson(userJson);
      } else {
        throw Exception("Anauthorized user");
      }
    } catch (error) {
      throw Exception("AuAuthorized Request: Failed to verify user");
    }
  }
}
