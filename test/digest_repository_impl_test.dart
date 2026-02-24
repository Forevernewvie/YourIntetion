import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:vibecodingexpert/features/digest/data/datasources/digest_local_data_source.dart';
import 'package:vibecodingexpert/features/digest/data/datasources/digest_remote_data_source.dart';
import 'package:vibecodingexpert/features/digest/data/models/digest_response_dto.dart';
import 'package:vibecodingexpert/features/digest/data/repositories/digest_repository_impl.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/feedback_event.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/rule_profile.dart';

/// Purpose: Verify digest repository caching and remote fallbacks remain deterministic.
void main() {
  group('DigestRepositoryImpl', () {
    test('uses any-profile cache when ruleProfileId is empty', () async {
      final remote = _FakeDigestRemoteDataSource();
      final local = _FakeDigestLocalDataSource(
        anyProfileDigest: _sampleDigest(profileId: 'cached_profile'),
      );
      final repository = DigestRepositoryImpl(remote: remote, local: local);

      final digest = await repository.getLatestDigest(ruleProfileId: '');

      expect(digest.profileId, 'cached_profile');
      expect(remote.fetchLatestCalls, 0);
    });

    test('falls back to remote when cache is missing', () async {
      final remote = _FakeDigestRemoteDataSource(
        latestDigest: _sampleDigest(profileId: 'remote_profile'),
      );
      final local = _FakeDigestLocalDataSource();
      final repository = DigestRepositoryImpl(remote: remote, local: local);

      final digest = await repository.getLatestDigest(ruleProfileId: '');

      expect(digest.profileId, 'remote_profile');
      expect(remote.fetchLatestCalls, 1);
      expect(local.savedDigests.length, 1);
    });

    test('create/update profile routing remains deterministic', () async {
      final remote = _FakeDigestRemoteDataSource(
        createdProfile: _sampleProfile(id: 'created_profile', version: 2),
        updatedProfile: _sampleProfile(id: 'updated_profile', version: 3),
      );
      final local = _FakeDigestLocalDataSource();
      final repository = DigestRepositoryImpl(remote: remote, local: local);

      final created = await repository.saveRuleProfile(
        profile: _sampleProfile(id: '', version: 1),
      );
      final updated = await repository.saveRuleProfile(
        profile: _sampleProfile(id: 'existing_profile', version: 2),
      );

      expect(created.id, 'created_profile');
      expect(updated.id, 'updated_profile');
      expect(remote.createCalls, 1);
      expect(remote.updateCalls, 1);
      expect(local.savedProfiles.length, 2);
      expect(
        jsonDecode(local.savedProfiles.first.profileJson)['id'],
        'created_profile',
      );
    });
  });
}

/// Purpose: Provide fake remote datasource for repository unit tests.
final class _FakeDigestRemoteDataSource implements DigestRemoteDataSource {
  _FakeDigestRemoteDataSource({
    DigestResponseDto? latestDigest,
    RuleProfile? createdProfile,
    RuleProfile? updatedProfile,
  }) : _latestDigest = latestDigest ?? _sampleDigest(profileId: 'remote'),
       _createdProfile =
           createdProfile ?? _sampleProfile(id: 'created', version: 1),
       _updatedProfile =
           updatedProfile ?? _sampleProfile(id: 'updated', version: 2);

  final DigestResponseDto _latestDigest;
  final RuleProfile _createdProfile;
  final RuleProfile _updatedProfile;

  int fetchLatestCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;

  @override
  Future<RuleProfile> createRuleProfile({required RuleProfile profile}) async {
    createCalls++;
    return _createdProfile;
  }

  @override
  Future<DigestResponseDto> fetchDigestById({required String digestId}) {
    return Future.value(_latestDigest.copyWith(id: digestId));
  }

  @override
  Future<DigestResponseDto> fetchLatestDigest({
    required String ruleProfileId,
  }) async {
    fetchLatestCalls++;
    return _latestDigest;
  }

  @override
  Future<FeedbackEvent> submitFeedback({required FeedbackEvent feedback}) {
    return Future.value(feedback);
  }

  @override
  Future<RuleProfile> updateRuleProfile({required RuleProfile profile}) async {
    updateCalls++;
    return _updatedProfile;
  }
}

/// Purpose: Provide fake local datasource for deterministic repository unit tests.
final class _FakeDigestLocalDataSource implements DigestLocalDataSource {
  _FakeDigestLocalDataSource({this.anyProfileDigest});

  final DigestResponseDto? anyProfileDigest;
  final List<DigestResponseDto> savedDigests = <DigestResponseDto>[];
  final List<_SavedProfile> savedProfiles = <_SavedProfile>[];

  @override
  Future<DigestResponseDto?> readLatestValidDigest({
    required String profileId,
  }) async {
    return null;
  }

  @override
  Future<DigestResponseDto?> readLatestValidDigestAnyProfile() async {
    return anyProfileDigest;
  }

  @override
  Future<void> saveDigest(DigestResponseDto digest) async {
    savedDigests.add(digest);
  }

  @override
  Future<void> saveRuleProfile({
    required String profileId,
    required int version,
    required String profileJson,
  }) async {
    savedProfiles.add(
      _SavedProfile(
        profileId: profileId,
        version: version,
        profileJson: profileJson,
      ),
    );
  }
}

/// Purpose: Represent serialized saved profile metadata in fake local datasource.
final class _SavedProfile {
  const _SavedProfile({
    required this.profileId,
    required this.version,
    required this.profileJson,
  });

  final String profileId;
  final int version;
  final String profileJson;
}

/// Purpose: Build deterministic sample digest payload for unit tests.
DigestResponseDto _sampleDigest({required String profileId}) {
  final now = DateTime.utc(2026, 2, 24, 0, 0, 0);
  return DigestResponseDto(
    id: 'digest_1',
    profileId: profileId,
    generatedAt: now,
    qualityScore: 0.8,
    items: [
      DigestItemDto(
        id: 'item_1',
        topic: 'AI',
        whyReason: 'matched rule',
        summary: 'summary',
        freshnessMinutes: 5,
        citations: [
          CitationDto(
            id: 'cit_1',
            sourceName: 'Source',
            canonicalUrl: Uri.parse('https://example.com'),
            publishedAt: now,
          ),
        ],
      ),
    ],
  );
}

/// Purpose: Build deterministic sample rule profile payload for unit tests.
RuleProfile _sampleProfile({required String id, required int version}) {
  return RuleProfile(
    id: id,
    version: version,
    topicPriorities: const {'AI': 80},
    hardFilters: const <String>[],
    sourceAllowlist: const <String>[],
    sourceBlocklist: const <String>[],
    tone: SummaryTone.neutral,
    frequency: DigestFrequency.daily,
    length: DigestLength.quick,
    rankingTweaks: const {'trustBoost': 1},
    updatedAt: DateTime.utc(2026, 2, 24, 0, 0, 0),
  );
}
