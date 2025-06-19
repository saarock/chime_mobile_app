import 'package:chime/app/constant/api_endpoints.dart';
import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/core/network/dio_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'cookie_interceptor.dart';

class ApiService {
  final Dio _dio;
  final CookieJar _cookieJar = CookieJar();

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      ..options.extra = {'withCredentials': true}
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..interceptors.add(CookieManager(_cookieJar))
      ..interceptors.add(
        CookieInterceptor(getAccessToken: () => CookieCache.getAccessToken()),
      );
  }
}
