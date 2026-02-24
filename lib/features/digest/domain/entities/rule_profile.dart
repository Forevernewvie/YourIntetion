import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';

part 'rule_profile.freezed.dart';
part 'rule_profile.g.dart';

/// Purpose: Model tone presets for deterministic summary rendering.
enum SummaryTone { neutral, analytical, optimistic, critical, executive }

/// Purpose: Model digest frequency policies.
enum DigestFrequency { daily, weekdays, threePerWeek }

/// Purpose: Model digest length budgets.
enum DigestLength { quick, standard, deep }

/// Purpose: Expose max item budget for each digest length policy.
extension DigestLengthBudget on DigestLength {
  /// Purpose: Return the max number of digest items allowed by policy.
  int get maxItems {
    switch (this) {
      case DigestLength.quick:
        return AppConstants.digestQuickMaxItems;
      case DigestLength.standard:
        return AppConstants.digestStandardMaxItems;
      case DigestLength.deep:
        return AppConstants.digestDeepMaxItems;
    }
  }
}

/// Purpose: Represent user-defined deterministic summary rules.
@freezed
class RuleProfile with _$RuleProfile {
  /// Purpose: Construct an immutable rule profile.
  const factory RuleProfile({
    required String id,
    required int version,
    required Map<String, int> topicPriorities,
    required List<String> hardFilters,
    required List<String> sourceAllowlist,
    required List<String> sourceBlocklist,
    required SummaryTone tone,
    required DigestFrequency frequency,
    required DigestLength length,
    required Map<String, int> rankingTweaks,
    required DateTime updatedAt,
  }) = _RuleProfile;

  /// Purpose: Deserialize a rule profile from JSON.
  factory RuleProfile.fromJson(Map<String, dynamic> json) =>
      _$RuleProfileFromJson(json);
}

/// Purpose: Provide utility methods for rule lookup operations.
extension RuleProfileX on RuleProfile {
  /// Purpose: Return the configured topic weight or zero when absent.
  int topicWeight(String topic) => topicPriorities[topic] ?? 0;

  /// Purpose: Check if source domain is explicitly blocked.
  bool isBlockedSource(String sourceDomain) =>
      sourceBlocklist.contains(sourceDomain);

  /// Purpose: Check if source domain is explicitly allowed.
  bool isAllowedSource(String sourceDomain) {
    if (sourceAllowlist.isEmpty) {
      return true;
    }
    return sourceAllowlist.contains(sourceDomain);
  }
}
