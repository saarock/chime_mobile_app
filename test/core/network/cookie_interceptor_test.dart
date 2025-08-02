import 'package:chime/core/network/cookie_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for RequestInterceptorHandler
class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

// Fake class for RequestOptions fallback
class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  // Register fallback value once before all tests (required by mocktail for non-primitive types)
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  late CookieInterceptor interceptor;
  late RequestOptions requestOptions;
  late MockRequestInterceptorHandler handler;

  setUp(() {
    handler = MockRequestInterceptorHandler();
    requestOptions = RequestOptions(path: '/test');
    requestOptions.headers.clear();
  });

  test('onRequest adds Cookie header when access token is returned', () async {
    final token = 'fakeToken123';
    interceptor = CookieInterceptor(getAccessToken: () async => token);

    // Mock handler.next to do nothing
    when(() => handler.next(any())).thenReturn(null);

    await interceptor.onRequest(requestOptions, handler);

    // Assert header is set correctly
    expect(requestOptions.headers['Cookie'], 'accessToken=$token');

    // Verify handler.next is called once with the requestOptions
    verify(() => handler.next(requestOptions)).called(1);
  });

  test(
    'onRequest does NOT add Cookie header when access token is null',
    () async {
      interceptor = CookieInterceptor(getAccessToken: () async => null);

      when(() => handler.next(any())).thenReturn(null);

      await interceptor.onRequest(requestOptions, handler);

      // Assert header key 'Cookie' is NOT present
      expect(requestOptions.headers.containsKey('Cookie'), isFalse);

      verify(() => handler.next(requestOptions)).called(1);
    },
  );
}
