import '../../domain/entities/feedback_event.dart';
import '../../domain/repositories/digest_repository.dart';

/// Purpose: Submit feedback event for digest quality tuning loops.
final class SubmitFeedbackUseCase {
  /// Purpose: Construct use case with repository dependency.
  const SubmitFeedbackUseCase(this._repository);

  final DigestRepository _repository;

  /// Purpose: Execute feedback submission.
  Future<FeedbackEvent> call({required FeedbackEvent feedback}) {
    return _repository.submitFeedback(feedback: feedback);
  }
}
