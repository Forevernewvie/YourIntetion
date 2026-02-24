import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/session_providers.dart';
import 'dio_factory.dart';

/// Purpose: Provide configured Dio client with dynamic auth token attachment.
final dioProvider = Provider<Dio>((ref) {
  final dio = DioFactory.create(
    accessTokenReader: () => ref.read(accessTokenProvider),
  );
  ref.onDispose(dio.close);
  return dio;
});
