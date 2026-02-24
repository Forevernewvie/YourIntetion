import 'dart:convert';

import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/citation.dart';
import '../../domain/entities/digest.dart';
import '../../domain/entities/digest_item.dart';
import '../../domain/entities/feedback_event.dart';
import '../../domain/entities/rule_profile.dart';
import '../../domain/repositories/digest_repository.dart';
import '../datasources/digest_local_data_source.dart';
import '../datasources/digest_remote_data_source.dart';
import '../models/digest_response_dto.dart';

/// Purpose: Bridge digest domain repository contract to remote and local data sources.
final class DigestRepositoryImpl implements DigestRepository {
  /// Purpose: Construct repository with isolated datasource dependencies.
  const DigestRepositoryImpl({
    required DigestRemoteDataSource remote,
    required DigestLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final DigestRemoteDataSource _remote;
  final DigestLocalDataSource _local;

  /// Purpose: Return latest digest using stale-while-revalidate semantics.
  @override
  Future<Digest> getLatestDigest({required String ruleProfileId}) async {
    final normalizedProfileId = ruleProfileId.trim();
    final cached = normalizedProfileId.isEmpty
        ? await _local.readLatestValidDigestAnyProfile()
        : await _local.readLatestValidDigest(profileId: normalizedProfileId);
    if (cached != null && cached.items.isNotEmpty) {
      AppLogger.info('digest_cache_hit', fields: {'profileId': ruleProfileId});
      return _toDomain(cached);
    }

    final remote = await _remote.fetchLatestDigest(
      ruleProfileId: normalizedProfileId,
    );
    await _local.saveDigest(remote);
    return _toDomain(remote);
  }

  /// Purpose: Return digest detail by id from remote source.
  @override
  Future<Digest> getDigestById({required String digestId}) async {
    final remote = await _remote.fetchDigestById(digestId: digestId);
    await _local.saveDigest(remote);
    return _toDomain(remote);
  }

  /// Purpose: Return saved digest list for MVP from cached latest profile entry.
  @override
  Future<List<Digest>> getSavedDigests() async {
    final digest = await getLatestDigest(ruleProfileId: '');
    return [digest];
  }

  /// Purpose: Persist rule profile and return saved profile.
  @override
  Future<RuleProfile> saveRuleProfile({required RuleProfile profile}) async {
    if (profile.sourceAllowlist
        .toSet()
        .intersection(profile.sourceBlocklist.toSet())
        .isNotEmpty) {
      AppLogger.warn(
        'rule_profile_overlap_detected',
        fields: {'profileId': profile.id},
      );
    }

    final savedRemote = profile.id.trim().isEmpty
        ? await _remote.createRuleProfile(profile: profile)
        : await _remote.updateRuleProfile(profile: profile);

    await _local.saveRuleProfile(
      profileId: savedRemote.id,
      version: savedRemote.version,
      profileJson: jsonEncode(savedRemote.toJson()),
    );

    return savedRemote;
  }

  /// Purpose: Persist feedback event for MVP with lightweight confirmation.
  @override
  Future<FeedbackEvent> submitFeedback({
    required FeedbackEvent feedback,
  }) async {
    if (feedback.rating < 1 || feedback.rating > 5) {
      throw const AppFailure(
        code: AppErrorCode.ruleValidation,
        message: 'Feedback rating out of allowed range.',
      );
    }

    final saved = await _remote.submitFeedback(feedback: feedback);
    AppLogger.info(
      'feedback_submitted',
      fields: {'itemId': saved.itemId, 'rating': saved.rating},
    );
    return saved;
  }

  /// Purpose: Convert transport digest dto to domain digest entity.
  Digest _toDomain(DigestResponseDto dto) {
    return Digest(
      id: dto.id,
      profileId: dto.profileId,
      generatedAt: dto.generatedAt,
      qualityScore: dto.qualityScore,
      items: dto.items.map(_toDomainItem).toList(growable: false),
    );
  }

  /// Purpose: Convert transport digest item dto to domain entity.
  DigestItem _toDomainItem(DigestItemDto dto) {
    return DigestItem(
      id: dto.id,
      topic: dto.topic,
      whyReason: dto.whyReason,
      summary: dto.summary,
      freshnessMinutes: dto.freshnessMinutes,
      citations: dto.citations.map(_toDomainCitation).toList(growable: false),
    );
  }

  /// Purpose: Convert transport citation dto to domain entity.
  Citation _toDomainCitation(CitationDto dto) {
    return Citation(
      id: dto.id,
      sourceName: dto.sourceName,
      canonicalUrl: dto.canonicalUrl,
      publishedAt: dto.publishedAt,
    );
  }
}
