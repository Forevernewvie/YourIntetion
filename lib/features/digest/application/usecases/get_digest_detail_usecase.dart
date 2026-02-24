import '../../domain/entities/digest.dart';
import '../../domain/repositories/digest_repository.dart';

/// Purpose: Orchestrate retrieval of one digest detail record.
final class GetDigestDetailUseCase {
  /// Purpose: Construct use case with repository dependency.
  const GetDigestDetailUseCase(this._repository);

  final DigestRepository _repository;

  /// Purpose: Execute digest detail retrieval by id.
  Future<Digest> call({required String digestId}) {
    return _repository.getDigestById(digestId: digestId);
  }
}
