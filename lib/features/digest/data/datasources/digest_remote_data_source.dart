import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/feedback_event.dart';
import '../../domain/entities/rule_profile.dart';
import '../models/digest_response_dto.dart';

/// Purpose: Define remote data access contract for digest features.
abstract interface class DigestRemoteDataSource {
  /// Purpose: Fetch latest digest payload for a rule profile from API.
  Future<DigestResponseDto> fetchLatestDigest({required String ruleProfileId});

  /// Purpose: Fetch digest payload by digest id from API.
  Future<DigestResponseDto> fetchDigestById({required String digestId});

  /// Purpose: Create a new rule profile using backend API.
  Future<RuleProfile> createRuleProfile({required RuleProfile profile});

  /// Purpose: Update an existing rule profile using backend API.
  Future<RuleProfile> updateRuleProfile({required RuleProfile profile});

  /// Purpose: Submit feedback event to backend API.
  Future<FeedbackEvent> submitFeedback({required FeedbackEvent feedback});
}

/// Purpose: Execute digest API calls using Dio.
final class DigestRemoteDataSourceImpl implements DigestRemoteDataSource {
  /// Purpose: Construct remote datasource with external Dio dependency.
  DigestRemoteDataSourceImpl(this._dio);

  final Dio _dio;
  final Map<String, _LatestDigestCacheEntry> _latestDigestMemoryCache =
      <String, _LatestDigestCacheEntry>{};

  /// Purpose: Fetch latest digest payload from backend.
  @override
  Future<DigestResponseDto> fetchLatestDigest({
    required String ruleProfileId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      final profileId = ruleProfileId.trim();
      if (profileId.isNotEmpty) {
        final cached = _latestDigestMemoryCache[profileId];
        if (cached != null &&
            DateTime.now()
                    .difference(cached.cachedAt)
                    .compareTo(AppConstants.remoteLatestDigestMemoryTtl) <
                0) {
          return cached.digest;
        }
      }

      if (profileId.isNotEmpty) {
        queryParameters['ruleProfileId'] = profileId;
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/digests/latest',
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data == null) {
        throw const AppFailure(
          code: AppErrorCode.apiBadResponse,
          message: 'Empty digest response payload.',
        );
      }

      final dto = DigestResponseDto.fromJson(data);
      if (profileId.isNotEmpty) {
        _latestDigestMemoryCache[profileId] = _LatestDigestCacheEntry(
          digest: dto,
          cachedAt: DateTime.now(),
        );
      }
      return dto;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'digest_remote_latest_error',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioException(
        error,
        fallbackMessage: 'Failed to fetch latest digest.',
      );
    }
  }

  /// Purpose: Fetch specific digest payload by id from backend.
  @override
  Future<DigestResponseDto> fetchDigestById({required String digestId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/digests/$digestId',
      );
      final data = response.data;
      if (data == null) {
        throw const AppFailure(
          code: AppErrorCode.apiBadResponse,
          message: 'Empty digest detail payload.',
        );
      }
      return DigestResponseDto.fromJson(data);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'digest_remote_detail_error',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioException(
        error,
        fallbackMessage: 'Failed to fetch digest detail.',
      );
    }
  }

  /// Purpose: Create rule profile on backend and return normalized domain entity.
  @override
  Future<RuleProfile> createRuleProfile({required RuleProfile profile}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/rules/profiles',
        data: _ruleRequestBody(profile),
      );
      final data = response.data;
      if (data == null) {
        throw const AppFailure(
          code: AppErrorCode.apiBadResponse,
          message: 'Empty rule profile create response payload.',
        );
      }
      _latestDigestMemoryCache.clear();
      return _ruleProfileFromJson(data);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'rule_profile_create_error',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioException(
        error,
        fallbackMessage: 'Failed to create rule profile.',
      );
    }
  }

  /// Purpose: Update existing rule profile and return normalized domain entity.
  @override
  Future<RuleProfile> updateRuleProfile({required RuleProfile profile}) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/v1/rules/profiles/${profile.id}',
        data: _ruleRequestBody(profile),
      );
      final data = response.data;
      if (data == null) {
        throw const AppFailure(
          code: AppErrorCode.apiBadResponse,
          message: 'Empty rule profile update response payload.',
        );
      }
      _latestDigestMemoryCache.clear();
      return _ruleProfileFromJson(data);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'rule_profile_update_error',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioException(
        error,
        fallbackMessage: 'Failed to update rule profile.',
      );
    }
  }

  /// Purpose: Submit feedback event and return persisted feedback payload.
  @override
  Future<FeedbackEvent> submitFeedback({required FeedbackEvent feedback}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/feedback',
        data: {
          'digestItemId': feedback.itemId,
          'rating': feedback.rating,
          'reason': feedback.reason,
        },
      );
      final data = response.data;
      if (data == null) {
        throw const AppFailure(
          code: AppErrorCode.apiBadResponse,
          message: 'Empty feedback response payload.',
        );
      }

      return FeedbackEvent(
        id: (data['id'] as String?) ?? feedback.id,
        itemId: (data['digestItemId'] as String?) ?? feedback.itemId,
        rating: (data['rating'] as num?)?.toInt() ?? feedback.rating,
        reason: (data['reason'] as String?) ?? feedback.reason,
        createdAt:
            DateTime.tryParse((data['createdAt'] as String?) ?? '')?.toUtc() ??
                feedback.createdAt.toUtc(),
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'feedback_submit_error',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioException(
        error,
        fallbackMessage: 'Failed to submit feedback.',
      );
    }
  }

  /// Purpose: Map backend rule profile response payload to domain entity.
  RuleProfile _ruleProfileFromJson(Map<String, dynamic> json) {
    final topicPrioritiesRaw =
        (json['topicPriorities'] as Map<String, dynamic>?) ?? const {};
    final rankingTweaksRaw =
        (json['rankingTweaks'] as Map<String, dynamic>?) ?? const {};
    final now = DateTime.now().toUtc();

    return RuleProfile(
      id: (json['id'] as String?) ?? '',
      version: (json['version'] as num?)?.toInt() ?? 1,
      topicPriorities: topicPrioritiesRaw.map(
        (key, value) => MapEntry(key, _normalizeWeight(value)),
      ),
      hardFilters: (json['hardFilters'] as List<dynamic>? ?? const [])
          .map((entry) => entry.toString())
          .toList(growable: false),
      sourceAllowlist: (json['sourceAllowlist'] as List<dynamic>? ?? const [])
          .map((entry) => entry.toString())
          .toList(growable: false),
      sourceBlocklist: (json['sourceBlocklist'] as List<dynamic>? ?? const [])
          .map((entry) => entry.toString())
          .toList(growable: false),
      tone: _parseTone((json['tone'] as String?) ?? 'neutral'),
      frequency:
          _parseFrequency((json['frequency'] as String?) ?? 'threePerWeek'),
      length: _parseLength((json['length'] as String?) ?? 'quick'),
      rankingTweaks: rankingTweaksRaw.map(
        (key, value) => MapEntry(key, (value as num?)?.round() ?? 0),
      ),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '')
              ?.toUtc() ??
          now,
    );
  }

  /// Purpose: Build backend rule profile request body from domain entity.
  Map<String, dynamic> _ruleRequestBody(RuleProfile profile) {
    return {
      'version': profile.version,
      'topic_priorities': profile.topicPriorities.map(
        (key, value) => MapEntry(key, _normalizeBackendPriority(value)),
      ),
      'hard_filters': profile.hardFilters,
      'source_allowlist': profile.sourceAllowlist,
      'source_blocklist': profile.sourceBlocklist,
      'tone': profile.tone.name,
      'frequency': profile.frequency.name,
      'length': profile.length.name,
      'ranking_tweaks': profile.rankingTweaks,
    };
  }

  /// Purpose: Normalize domain priority values into backend numeric scale.
  double _normalizeBackendPriority(int value) {
    if (value <= 1) {
      return value.toDouble();
    }

    return (value / 100).clamp(0, 1);
  }

  /// Purpose: Normalize backend priority values into integer UI-oriented scale.
  int _normalizeWeight(Object? raw) {
    final value = (raw as num?)?.toDouble() ?? 0;
    if (value <= 1.0) {
      return (value * 100).round();
    }
    return value.round();
  }

  /// Purpose: Parse backend tone value to domain enum with safe default.
  SummaryTone _parseTone(String value) {
    return SummaryTone.values.firstWhere(
      (tone) => tone.name == value,
      orElse: () => SummaryTone.neutral,
    );
  }

  /// Purpose: Parse backend frequency value to domain enum with safe default.
  DigestFrequency _parseFrequency(String value) {
    return DigestFrequency.values.firstWhere(
      (frequency) => frequency.name == value,
      orElse: () => DigestFrequency.threePerWeek,
    );
  }

  /// Purpose: Parse backend length value to domain enum with safe default.
  DigestLength _parseLength(String value) {
    return DigestLength.values.firstWhere(
      (length) => length.name == value,
      orElse: () => DigestLength.quick,
    );
  }

  /// Purpose: Convert transport exceptions into normalized application failures.
  AppFailure _mapDioException(
    DioException error, {
    required String fallbackMessage,
  }) {
    final statusCode = error.response?.statusCode ?? 0;

    if (statusCode == 401 || statusCode == 403) {
      return const AppFailure(
        code: AppErrorCode.netUnauthorized,
        message: 'Authentication required to access this resource.',
      );
    }
    if (statusCode >= 400 && statusCode < 500) {
      return AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: error.response?.data is Map<String, dynamic>
            ? (((error.response?.data as Map<String, dynamic>)['message']
                        as String?) ??
                    fallbackMessage)
            : fallbackMessage,
        cause: error,
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AppFailure(
        code: AppErrorCode.netTimeout,
        message: 'Network timeout while requesting backend API.',
      );
    }

    return AppFailure(
      code: AppErrorCode.unknown,
      message: fallbackMessage,
      cause: error,
    );
  }
}

/// Purpose: Keep short-lived in-memory latest digest cache entry.
final class _LatestDigestCacheEntry {
  /// Purpose: Construct cache entry with payload and capture time.
  const _LatestDigestCacheEntry({
    required this.digest,
    required this.cachedAt,
  });

  final DigestResponseDto digest;
  final DateTime cachedAt;
}
