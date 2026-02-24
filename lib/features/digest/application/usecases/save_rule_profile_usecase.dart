import '../../domain/entities/rule_profile.dart';
import '../../domain/repositories/digest_repository.dart';

/// Purpose: Persist a rule profile update through repository abstraction.
final class SaveRuleProfileUseCase {
  /// Purpose: Construct use case with repository dependency.
  const SaveRuleProfileUseCase(this._repository);

  final DigestRepository _repository;

  /// Purpose: Execute rule profile persistence.
  Future<RuleProfile> call({required RuleProfile profile}) {
    return _repository.saveRuleProfile(profile: profile);
  }
}
