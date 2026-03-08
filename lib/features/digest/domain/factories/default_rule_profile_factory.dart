import '../entities/rule_profile.dart';

/// Purpose: Create deterministic default rule profiles for bootstrap and tests.
final class DefaultRuleProfileFactory {
  DefaultRuleProfileFactory._();

  /// Purpose: Build the default active rule profile used before user customization.
  static RuleProfile create({DateTime? updatedAt}) {
    return RuleProfile(
      id: '',
      version: 1,
      topicPriorities: const {'AI': 90, 'Markets': 80, 'Science': 60},
      hardFilters: const ['Celebrity Gossip'],
      sourceAllowlist: const <String>[],
      sourceBlocklist: const <String>[],
      tone: SummaryTone.neutral,
      frequency: DigestFrequency.weekdays,
      length: DigestLength.quick,
      rankingTweaks: const {'community': 10, 'video': 5},
      updatedAt: (updatedAt ?? DateTime.now()).toUtc(),
    );
  }
}
