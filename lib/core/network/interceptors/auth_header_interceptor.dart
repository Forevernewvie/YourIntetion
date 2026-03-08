import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';

/// Purpose: Attach bearer authorization headers using the current access token source.
final class AuthHeaderInterceptor extends Interceptor {
  /// Purpose: Construct auth header interceptor with dynamic token reader dependency.
  AuthHeaderInterceptor({required String? Function() accessTokenReader})
    : _accessTokenReader = accessTokenReader;

  final String? Function() _accessTokenReader;

  /// Purpose: Add authorization header only when a non-empty access token exists.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _accessTokenReader();
    if (token != null && token.isNotEmpty) {
      options.headers[AppNetworkKey.authorizationHeader] =
          '${AppNetworkValue.bearerScheme} $token';
    }
    handler.next(options);
  }
}
