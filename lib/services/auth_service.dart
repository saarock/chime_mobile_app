import "package:chime/models/user_model.dart";
import "package:chime/services/api_service.dart";
import "package:chime/utils/token_storage.dart";
import "package:dio/dio.dart";

class AuthService {
  final Dio _dio = ApiService.getDio();

  Future<UserModel> loginWithGoogle({
    required String credentials,
    required String clientId,
  }) async {
    try {
      final response = await _dio.post(
        "login-with-google",
        data: {'credentials': credentials, 'clientId': clientId},
      );

      final data = response.data;

      final userPayload = data['data'];

      if (userPayload == null) {
        throw new Exception("Login failed");
      }

      await TokenStorage.saveTokens(
        userPayload['accessToken'],
        userPayload['refreshToken'],
      );
      final user = UserModel.fromJson(userPayload['userData']);

      await TokenStorage.saveUser(user);

      return user;
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }
}
