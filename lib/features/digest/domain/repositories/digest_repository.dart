import '../entities/digest.dart';
import '../entities/feedback_event.dart';
import '../entities/rule_profile.dart';

/// Purpose: Define digest data operations independent of infrastructure details.
abstract interface class DigestRepository {
  /// Purpose: Return the latest digest for a specific rule profile.
  Future<Digest> getLatestDigest({required String ruleProfileId});

  /// Purpose: Return a digest by id.
  Future<Digest> getDigestById({required String digestId});

  /// Purpose: Return a list of saved digests for current user context.
  Future<List<Digest>> getSavedDigests();

  /// Purpose: Persist an updated rule profile and return stored profile.
  Future<RuleProfile> saveRuleProfile({required RuleProfile profile});

  /// Purpose: Submit feedback event and return persisted event.
  Future<FeedbackEvent> submitFeedback({required FeedbackEvent feedback});
}
