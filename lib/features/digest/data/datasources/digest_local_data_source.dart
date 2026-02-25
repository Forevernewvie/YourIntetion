import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../local/isar/digest_cache_entity.dart';
import '../local/isar/rule_profile_cache_entity.dart';
import '../models/digest_response_dto.dart';

/// Purpose: Define local cache contract for digest domain data.
abstract interface class DigestLocalDataSource {
  /// Purpose: Save digest payload in local cache with ttl metadata.
  Future<void> saveDigest(DigestResponseDto digest);

  /// Purpose: Return latest valid digest by profile id if cache is valid.
  Future<DigestResponseDto?> readLatestValidDigest({required String profileId});

  /// Purpose: Return latest valid digest from any profile when profile id is unknown.
  Future<DigestResponseDto?> readLatestValidDigestAnyProfile();

  /// Purpose: Persist serialized rule profile json snapshot.
  Future<void> saveRuleProfile({
    required String profileId,
    required int version,
    required String profileJson,
  });
}

/// Purpose: Implement Isar-backed local cache behavior for digest feature.
final class DigestLocalDataSourceImpl implements DigestLocalDataSource {
  /// Purpose: Construct local datasource with external Isar dependency.
  const DigestLocalDataSourceImpl(this._isar);

  final Isar _isar;

  /// Purpose: Decode cached digest JSON safely into DTO while preserving error context.
  DigestResponseDto _decodeCachedDigest({
    required String digestJson,
    required String errorEvent,
  }) {
    try {
      return DigestResponseDto.fromJson(
        jsonDecode(digestJson) as Map<String, dynamic>,
      );
    } catch (error, stackTrace) {
      AppLogger.error(errorEvent, error: error, stackTrace: stackTrace);
      throw const AppFailure(
        code: AppErrorCode.storageFailure,
        message: 'Failed to decode cached digest payload.',
      );
    }
  }

  /// Purpose: Save digest with deterministic expiration timestamp.
  @override
  Future<void> saveDigest(DigestResponseDto digest) async {
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(
      const Duration(minutes: AppConstants.cacheDigestTtlMinutes),
    );

    final entity = DigestCacheEntity()
      ..digestId = digest.id
      ..profileId = digest.profileId
      ..digestJson = jsonEncode(digest.toJson())
      ..generatedAt = digest.generatedAt
      ..expiresAt = expiresAt;

    await _isar.writeTxn(() async {
      await _isar.digestCacheEntitys.put(entity);
    });

    AppLogger.info('digest_cache_saved', fields: {'digestId': digest.id});
  }

  /// Purpose: Read latest non-expired digest from local cache for requested profile.
  @override
  Future<DigestResponseDto?> readLatestValidDigest({
    required String profileId,
  }) async {
    final now = DateTime.now().toUtc();
    final entity = await _isar.digestCacheEntitys
        .filter()
        .profileIdEqualTo(profileId)
        .and()
        .expiresAtGreaterThan(now)
        .sortByGeneratedAtDesc()
        .findFirst();

    if (entity == null) {
      return null;
    }

    return _decodeCachedDigest(
      digestJson: entity.digestJson,
      errorEvent: 'digest_cache_decode_failed',
    );
  }

  /// Purpose: Read latest non-expired digest without requiring known profile id.
  @override
  Future<DigestResponseDto?> readLatestValidDigestAnyProfile() async {
    final now = DateTime.now().toUtc();
    final entity = await _isar.digestCacheEntitys
        .filter()
        .expiresAtGreaterThan(now)
        .sortByGeneratedAtDesc()
        .findFirst();

    if (entity == null) {
      return null;
    }

    return _decodeCachedDigest(
      digestJson: entity.digestJson,
      errorEvent: 'digest_cache_decode_failed_any_profile',
    );
  }

  /// Purpose: Save serialized rule profile for startup continuity.
  @override
  Future<void> saveRuleProfile({
    required String profileId,
    required int version,
    required String profileJson,
  }) async {
    final existing = await _isar.ruleProfileCacheEntitys
        .filter()
        .profileIdEqualTo(profileId)
        .findFirst();

    final entity = existing ?? RuleProfileCacheEntity();
    entity.profileId = profileId;
    entity.version = version;
    entity.profileJson = profileJson;
    entity.updatedAt = DateTime.now().toUtc();

    await _isar.writeTxn(() async {
      await _isar.ruleProfileCacheEntitys.put(entity);
    });

    AppLogger.info(
      'rule_profile_cache_saved',
      fields: {'profileId': profileId, 'version': version},
    );
  }
}
