import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api/v1/users/', // base url for the API
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static bool _isInterceptorAdded = false;

  static Dio getDio() {
    if (!_isInterceptorAdded) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await TokenStorage.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            print('*** Request ***');
            print('URI: ${options.uri}');
            print('Headers: ${options.headers}');
            print('Data: ${options.data}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('*** Response ***');
            print('Status Code: ${response.statusCode}');
            print('Data: ${response.data}');
            return handler.next(response);
          },
          onError: (e, handler) async {
            print('*** Error ***');
            print(e);
            final status = e.response?.statusCode;
            final data = e.response?.data;
            if (status == 401 && data?['errorCode'] == 'token_expired') {
              final refreshed = await _refreshToken();
              if (refreshed) {
                final newToken = await TokenStorage.getAccessToken();
                final clonedRequest = e.requestOptions;
                clonedRequest.headers['Authorization'] = 'Bearer $newToken';

                final retryDio = Dio(BaseOptions());
                final response = await retryDio.fetch(clonedRequest);
                return handler.resolve(response);
              }
            }
            return handler.next(e);
          },
        ),
      );
      _isInterceptorAdded = true;
    }
    return _dio;
  }

  static Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final Dio refreshDio = Dio(
        BaseOptions(
          baseUrl: 'http://192.168.101.7:8000/api/v1/users/',
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      final response = await refreshDio.post(
        '/refresh',
        data: {'refreshToken': refreshToken},
      );

      await TokenStorage.saveTokens(
        response.data['accessToken'],
        response.data['refreshToken'],
      );

      return true;
    } catch (e) {
      print("Token refresh failed: $e");
      return false;
    }
  }
}
