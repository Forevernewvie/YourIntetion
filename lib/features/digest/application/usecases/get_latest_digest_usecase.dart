import '../../domain/entities/digest.dart';
import '../../domain/repositories/digest_repository.dart';

/// Purpose: Orchestrate retrieval of the latest digest for a rule profile.
final class GetLatestDigestUseCase {
  /// Purpose: Construct use case with repository dependency.
  const GetLatestDigestUseCase(this._repository);

  final DigestRepository _repository;

  /// Purpose: Execute latest digest retrieval.
  Future<Digest> call({required String ruleProfileId}) {
    return _repository.getLatestDigest(ruleProfileId: ruleProfileId);
  }
}
