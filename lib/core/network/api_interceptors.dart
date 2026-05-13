import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String Function() getAccessToken;
  final String Function() getRefreshToken;
  final Future<bool> Function() onTokenExpired;

  AuthInterceptor({
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.onTokenExpired,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = getAccessToken();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await onTokenExpired();
      if (refreshed) {
        final token = getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (retryError) {
          handler.next(err);
          return;
        }
      }
    }
    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _log('--> ${options.method} ${options.path}');
    _log('Headers: ${options.headers}');
    _log('Query Params: ${options.queryParameters}');
    if (options.data != null) {
      _log('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _log(
        '<-- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _log(
        '<-- ${err.response?.statusCode} ${err.requestOptions.path} (error: ${err.message})');
    handler.next(err);
  }

  void _log(String message) {
    // Replace with proper logger in production
    // ignore: avoid_print
    print('[API] $message');
  }
}
