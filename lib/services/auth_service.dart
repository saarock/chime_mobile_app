import 'package:chime/models/user_model.dart';
import 'package:chime/utils/token_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api/v1/users/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<UserModel> loginWithGoogle({
    required String credentials,
    required String clientId,
  }) async {
    try {
      print("yes(((((((((((())))))))))))");
      final response = await _dio.post(
        "login-with-google",
        data: {'credential': credentials, 'clientId': clientId},
      );
      print("(((((((((((((((object)))))))))))))))");
      print(response);

      final data = response.data;

      final userPayload = data['data'];

      if (userPayload == null) {
        throw Exception("Login failed");
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
