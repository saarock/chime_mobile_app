import 'package:chime/core/network/dio_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class FakeDioException extends Fake implements DioException {}

void main() {
  late DioErrorInterceptor interceptor;
  late MockErrorInterceptorHandler handler;
  late RequestOptions requestOptions;

  setUpAll(() {
    registerFallbackValue(FakeDioException());
  });

  setUp(() {
    interceptor = DioErrorInterceptor();
    handler = MockErrorInterceptorHandler();
    requestOptions = RequestOptions(path: '/test');
  });

  test(
    'calls handler with custom error message when response has error message',
    () {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 400,
        data: {'message': 'Invalid request'},
        statusMessage: 'Bad Request',
      );

      final dioException = DioException(
        requestOptions: requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

      // Capture the DioException passed to handler.next
      DioException? passedException;

      when(() => handler.next(any())).thenAnswer((invocation) {
        passedException = invocation.positionalArguments.first as DioException;
      });

      interceptor.onError(dioException, handler);

      expect(passedException, isNotNull);
      expect(passedException!.error, 'Invalid request');
      verify(() => handler.next(any())).called(1);
    },
  );

  test('returns statusMessage if no message field in response data', () {
    final response = Response(
      requestOptions: requestOptions,
      statusCode: 404,
      data: {}, // no 'message' field
      statusMessage: 'Not Found',
    );

    final dioException = DioException(
      requestOptions: requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );

    DioException? passedException;

    when(() => handler.next(any())).thenAnswer((invocation) {
      passedException = invocation.positionalArguments.first as DioException;
    });

    interceptor.onError(dioException, handler);

    expect(passedException, isNotNull);
    expect(passedException!.error, 'Not Found');
    verify(() => handler.next(any())).called(1);
  });

  test('returns "Something went wrong" if statusCode < 300', () {
    final response = Response(
      requestOptions: requestOptions,
      statusCode: 200,
      data: {},
      statusMessage: 'OK',
    );

    final dioException = DioException(
      requestOptions: requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );

    DioException? passedException;

    when(() => handler.next(any())).thenAnswer((invocation) {
      passedException = invocation.positionalArguments.first as DioException;
    });

    interceptor.onError(dioException, handler);

    expect(passedException, isNotNull);
    expect(passedException!.error, 'Something went wrong');
    verify(() => handler.next(any())).called(1);
  });

  test('returns "Connection error" if no response', () {
    final dioException = DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.connectionTimeout,
      error: 'Timeout',
    );

    DioException? passedException;

    when(() => handler.next(any())).thenAnswer((invocation) {
      passedException = invocation.positionalArguments.first as DioException;
    });

    interceptor.onError(dioException, handler);

    expect(passedException, isNotNull);
    expect(passedException!.error, 'Connection error');
    verify(() => handler.next(any())).called(1);
  });
}
