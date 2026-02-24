import '../entities/rule_profile.dart';
import '../entities/source_item.dart';

/// Purpose: Apply deterministic rule precedence without circular dependencies.
final class RuleResolver {
  /// Purpose: Resolve source candidates using fixed precedence.
  List<SourceItem> resolve({
    required RuleProfile profile,
    required List<SourceItem> candidates,
  }) {
    final hardFilterSet = profile.hardFilters.toSet();
    final sourceAllowSet = profile.sourceAllowlist.toSet();
    final sourceBlockSet = profile.sourceBlocklist.toSet();
    final sourceAllowEnabled = sourceAllowSet.isNotEmpty;

    final hardFiltered = _applyHardFilters(hardFilterSet, candidates);
    final sourceFiltered = _applySourceAllowBlock(
      sourceAllowSet: sourceAllowSet,
      sourceBlockSet: sourceBlockSet,
      sourceAllowEnabled: sourceAllowEnabled,
      items: hardFiltered,
    );
    final topicRanked = _applyTopicPriority(profile, sourceFiltered);
    final rankingAdjusted = _applyRankingTweaks(profile, topicRanked);
    return _applyLengthBudget(profile, rankingAdjusted);
  }

  /// Purpose: Remove candidates that violate hard filters.
  List<SourceItem> _applyHardFilters(
    Set<String> hardFilterSet,
    List<SourceItem> items,
  ) {
    if (hardFilterSet.isEmpty) {
      return items;
    }

    return items
        .where((item) => !hardFilterSet.contains(item.category))
        .toList();
  }

  /// Purpose: Apply source allow/block with blocklist taking precedence.
  List<SourceItem> _applySourceAllowBlock({
    required Set<String> sourceAllowSet,
    required Set<String> sourceBlockSet,
    required bool sourceAllowEnabled,
    required List<SourceItem> items,
  }) {
    return items.where((item) {
      if (sourceBlockSet.contains(item.sourceDomain)) {
        return false;
      }
      if (!sourceAllowEnabled) {
        return true;
      }
      return sourceAllowSet.contains(item.sourceDomain);
    }).toList();
  }

  /// Purpose: Sort candidates by configured topic priorities.
  List<SourceItem> _applyTopicPriority(
    RuleProfile profile,
    List<SourceItem> items,
  ) {
    final copy = [...items];
    copy.sort((a, b) {
      final bWeight = profile.topicWeight(b.topic);
      final aWeight = profile.topicWeight(a.topic);
      return bWeight.compareTo(aWeight);
    });
    return copy;
  }

  /// Purpose: Apply optional ranking tweaks after primary ranking.
  List<SourceItem> _applyRankingTweaks(
    RuleProfile profile,
    List<SourceItem> items,
  ) {
    final copy = [...items];
    copy.sort((a, b) {
      final aBoost = profile.rankingTweaks[a.category] ?? 0;
      final bBoost = profile.rankingTweaks[b.category] ?? 0;
      return bBoost.compareTo(aBoost);
    });
    return copy;
  }

  /// Purpose: Enforce digest length budget based on profile length policy.
  List<SourceItem> _applyLengthBudget(
    RuleProfile profile,
    List<SourceItem> items,
  ) {
    return items.take(profile.length.maxItems).toList();
  }
}
