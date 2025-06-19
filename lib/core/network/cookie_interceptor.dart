import 'package:dio/dio.dart';

class CookieInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;

  CookieInterceptor({required this.getAccessToken});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAccessToken();
    if (token != null) {
      options.headers['Cookie'] = 'accessToken=$token';
    }
    handler.next(options);
  }
}
