import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/citation.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/rule_profile.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/source_item.dart';
import 'package:vibecodingexpert/features/digest/domain/services/rule_resolver.dart';

/// Purpose: Validate deterministic precedence in rule resolution.
void main() {
  group('RuleResolver', () {
    /// Purpose: Ensure hard filters and source blocklist are applied before ranking.
    test('applies precedence correctly', () {
      final resolver = RuleResolver();
      final profile = RuleProfile(
        id: 'profile',
        version: 1,
        topicPriorities: const {'AI': 90, 'Markets': 80},
        hardFilters: const ['blocked_category'],
        sourceAllowlist: const ['allowed.com'],
        sourceBlocklist: const ['blocked.com'],
        tone: SummaryTone.neutral,
        frequency: DigestFrequency.daily,
        length: DigestLength.quick,
        rankingTweaks: const {'community': 10},
        updatedAt: DateTime.utc(2026, 2, 21),
      );

      final items = [
        _item(
          id: '1',
          topic: 'AI',
          category: 'blocked_category',
          sourceDomain: 'allowed.com',
        ),
        _item(
          id: '2',
          topic: 'Markets',
          category: 'community',
          sourceDomain: 'blocked.com',
        ),
        _item(
          id: '3',
          topic: 'Markets',
          category: 'community',
          sourceDomain: 'allowed.com',
        ),
        _item(
          id: '4',
          topic: 'AI',
          category: 'community',
          sourceDomain: 'allowed.com',
        ),
      ];

      final resolved = resolver.resolve(profile: profile, candidates: items);

      expect(resolved.map((e) => e.id), ['4', '3']);
    });

    /// Purpose: Ensure digest length policy enforces max item budget.
    test('enforces length budget', () {
      final resolver = RuleResolver();
      final profile = RuleProfile(
        id: 'profile',
        version: 1,
        topicPriorities: const {'AI': 90},
        hardFilters: const [],
        sourceAllowlist: const [],
        sourceBlocklist: const [],
        tone: SummaryTone.neutral,
        frequency: DigestFrequency.daily,
        length: DigestLength.quick,
        rankingTweaks: const {},
        updatedAt: DateTime.utc(2026, 2, 21),
      );

      final items = List.generate(
        10,
        (index) => _item(
          id: '$index',
          topic: 'AI',
          category: 'community',
          sourceDomain: 'allowed.com',
        ),
      );

      final resolved = resolver.resolve(profile: profile, candidates: items);
      expect(resolved.length, DigestLength.quick.maxItems);
    });

    /// Purpose: Ensure optimized resolver output matches legacy resolver output for deterministic parity.
    test('matches legacy resolver output deterministically', () {
      final resolver = RuleResolver();
      final profile = RuleProfile(
        id: 'profile',
        version: 1,
        topicPriorities: const {'AI': 90, 'Markets': 80, 'Science': 50},
        hardFilters: const ['blocked_category', 'spam'],
        sourceAllowlist: const ['allowed.com', 'trusted.org'],
        sourceBlocklist: const ['blocked.com'],
        tone: SummaryTone.neutral,
        frequency: DigestFrequency.daily,
        length: DigestLength.standard,
        rankingTweaks: const {'community': 10, 'news': 2},
        updatedAt: DateTime.utc(2026, 2, 21),
      );

      final candidates = List<SourceItem>.generate(
        250,
        (index) => _item(
          id: '$index',
          topic: index % 3 == 0
              ? 'AI'
              : index % 3 == 1
              ? 'Markets'
              : 'Science',
          category: index % 7 == 0
              ? 'blocked_category'
              : index % 5 == 0
              ? 'community'
              : 'news',
          sourceDomain: index % 11 == 0
              ? 'blocked.com'
              : index.isEven
              ? 'allowed.com'
              : 'trusted.org',
        ),
      );

      final optimized = resolver.resolve(
        profile: profile,
        candidates: candidates,
      );
      final legacy = _resolveLegacy(profile: profile, candidates: candidates);

      expect(
        listEquals(
          optimized.map((e) => e.id).toList(),
          legacy.map((e) => e.id).toList(),
        ),
        isTrue,
      );
    });
  });
}

/// Purpose: Create source items for concise test arrangement.
SourceItem _item({
  required String id,
  required String topic,
  required String category,
  required String sourceDomain,
}) {
  return SourceItem(
    id: id,
    topic: topic,
    category: category,
    sourceDomain: sourceDomain,
    title: 'title_$id',
    body: 'body_$id',
    publishedAt: DateTime.utc(2026, 2, 21),
    citations: [
      Citation(
        id: 'c_$id',
        sourceName: 'source_$id',
        canonicalUrl: Uri.parse('https://example.com/$id'),
        publishedAt: DateTime.utc(2026, 2, 21),
      ),
    ],
  );
}

/// Purpose: Reproduce pre-optimization resolver behavior as deterministic parity oracle.
List<SourceItem> _resolveLegacy({
  required RuleProfile profile,
  required List<SourceItem> candidates,
}) {
  final hardFiltered = candidates
      .where((item) => !profile.hardFilters.contains(item.category))
      .toList();

  final sourceFiltered = hardFiltered.where((item) {
    if (profile.sourceBlocklist.contains(item.sourceDomain)) {
      return false;
    }
    if (profile.sourceAllowlist.isEmpty) {
      return true;
    }
    return profile.sourceAllowlist.contains(item.sourceDomain);
  }).toList();

  final topicRanked = [...sourceFiltered]
    ..sort((a, b) {
      final bWeight = profile.topicWeight(b.topic);
      final aWeight = profile.topicWeight(a.topic);
      return bWeight.compareTo(aWeight);
    });

  final rankingAdjusted = [...topicRanked]
    ..sort((a, b) {
      final aBoost = profile.rankingTweaks[a.category] ?? 0;
      final bBoost = profile.rankingTweaks[b.category] ?? 0;
      return bBoost.compareTo(aBoost);
    });

  return rankingAdjusted.take(profile.length.maxItems).toList();
}
