import 'dart:io';
import 'dart:math';

import 'package:vibecodingexpert/features/digest/domain/entities/citation.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/rule_profile.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/source_item.dart';
import 'package:vibecodingexpert/features/digest/domain/services/rule_resolver.dart';

/// Purpose: Benchmark legacy vs optimized rule resolver complexity on realistic input sizes.
void main() {
  const scenarios = <_BenchmarkScenario>[
    _BenchmarkScenario(candidateCount: 1000, hardFilterCount: 1000),
    _BenchmarkScenario(candidateCount: 5000, hardFilterCount: 5000),
    _BenchmarkScenario(candidateCount: 10000, hardFilterCount: 10000),
  ];

  final resolver = RuleResolver();
  for (final scenario in scenarios) {
    final profile = _buildProfile(scenario.hardFilterCount);
    final candidates = _buildCandidates(scenario.candidateCount);

    final legacyMicros = _measureMicros(
      () => _resolveLegacy(profile: profile, candidates: candidates),
    );
    final optimizedMicros = _measureMicros(
      () => resolver.resolve(profile: profile, candidates: candidates),
    );

    final speedup = legacyMicros / optimizedMicros;
    stdout.writeln(
      'candidates=${scenario.candidateCount}'
      ' hardFilters=${scenario.hardFilterCount}'
      ' legacy=${legacyMicros}us'
      ' optimized=${optimizedMicros}us'
      ' speedup=${speedup.toStringAsFixed(2)}x',
    );
  }
}

/// Purpose: Measure average function execution time in microseconds.
int _measureMicros(List<SourceItem> Function() run) {
  const iterations = 14;
  const warmup = 4;
  final samples = <int>[];

  for (var i = 0; i < iterations; i++) {
    final watch = Stopwatch()..start();
    run();
    watch.stop();
    if (i >= warmup) {
      samples.add(watch.elapsedMicroseconds);
    }
  }

  samples.sort();
  return samples[samples.length ~/ 2];
}

/// Purpose: Build deterministic benchmark profile with scalable hard-filter count.
RuleProfile _buildProfile(int hardFilterCount) {
  final hardFilters = List<String>.generate(
    hardFilterCount,
    (index) => 'category_$index',
    growable: false,
  );

  return RuleProfile(
    id: 'bench',
    version: 1,
    topicPriorities: const {'AI': 90, 'Markets': 80, 'Science': 70},
    hardFilters: hardFilters,
    sourceAllowlist: const ['allowed.com', 'trusted.org'],
    sourceBlocklist: const ['blocked.com'],
    tone: SummaryTone.neutral,
    frequency: DigestFrequency.daily,
    length: DigestLength.deep,
    rankingTweaks: const {'community': 10, 'news': 3, 'science': 1},
    updatedAt: DateTime.utc(2026, 2, 24),
  );
}

/// Purpose: Build deterministic benchmark candidate items.
List<SourceItem> _buildCandidates(int count) {
  final random = Random(42);
  return List<SourceItem>.generate(count, (index) {
    final topicIndex = random.nextInt(3);
    final sourceDomain = switch (index % 4) {
      0 => 'allowed.com',
      1 => 'trusted.org',
      2 => 'blocked.com',
      _ => 'misc.net',
    };

    return SourceItem(
      id: 'item_$index',
      topic: topicIndex == 0
          ? 'AI'
          : topicIndex == 1
          ? 'Markets'
          : 'Science',
      category: 'category_${index % count}',
      sourceDomain: sourceDomain,
      title: 'title_$index',
      body: 'body_$index',
      publishedAt: DateTime.utc(2026, 2, 24),
      citations: [
        Citation(
          id: 'citation_$index',
          sourceName: 'source_$index',
          canonicalUrl: Uri.parse('https://example.com/$index'),
          publishedAt: DateTime.utc(2026, 2, 24),
        ),
      ],
    );
  }, growable: false);
}

/// Purpose: Reproduce legacy resolver behavior as benchmark baseline.
List<SourceItem> _resolveLegacy({
  required RuleProfile profile,
  required List<SourceItem> candidates,
}) {
  final hardFiltered = candidates
      .where((item) => !profile.hardFilters.contains(item.category))
      .toList(growable: false);

  final sourceFiltered = hardFiltered
      .where((item) {
        if (profile.sourceBlocklist.contains(item.sourceDomain)) {
          return false;
        }
        if (profile.sourceAllowlist.isEmpty) {
          return true;
        }
        return profile.sourceAllowlist.contains(item.sourceDomain);
      })
      .toList(growable: false);

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

  return rankingAdjusted.take(profile.length.maxItems).toList(growable: false);
}

/// Purpose: Hold benchmark scenario sizing parameters.
final class _BenchmarkScenario {
  const _BenchmarkScenario({
    required this.candidateCount,
    required this.hardFilterCount,
  });

  final int candidateCount;
  final int hardFilterCount;
}
