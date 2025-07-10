import 'package:chime/app/constant/api_endpoints.dart';
import 'package:chime/app/shared_pref/cooki_cache.dart';
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
        final accessToken = data['data']['accessToken'];
        await CookieCache.saveAccessToken(accessToken);
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
        print("Oh yes this is the actual rsponse of hte verify user");
        final data = response.data;
        // Extract userData
        final userJson = data['data']['userData'];
        return UserApiModel.fromJson(userJson);
      } else {
        throw Exception("Anauthorized user");
      }
    } catch (error) {
      throw Exception("AuAuthorized Request: Failed to verify user");
    }
  }

  @override
  Future<UserApiModel> updateUserImportantDetails(
    Map<String, dynamic> userDetails,
    UserApiModel existingUser,
  ) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.updateUserImportantDetails,
        data: userDetails,
      );

      if (response.statusCode == 200) {
        final partialUserJson = response.data['data'];

        // Create a partial UserApiModel from partial JSON
        final partialUser = UserApiModel.fromJson(partialUserJson);

        // Merge with existing user to produce a complete UserApiModel
        final mergedUser = existingUser.copyWith(
          id: partialUser.id,
          userName: partialUser.userName,
          age: partialUser.age,
          phoneNumber: partialUser.phoneNumber,
          country: partialUser.country,
          gender: partialUser.gender,
          relationShipStatus: partialUser.relationShipStatus,
          // other fields if sent by backend...
        );
        return mergedUser;
      } else {
        throw Exception("Failed to update user profile");
      }
    } catch (error) {
      print("This is the error ");
      print(error);

      throw Exception("Error while updating user profile: $error");
    }
  }
}
