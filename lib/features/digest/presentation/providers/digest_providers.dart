import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_providers.dart';
import '../../application/usecases/get_digest_detail_usecase.dart';
import '../../application/usecases/get_latest_digest_usecase.dart';
import '../../application/usecases/save_rule_profile_usecase.dart';
import '../../application/usecases/submit_feedback_usecase.dart';
import '../../data/datasources/digest_local_data_source.dart';
import '../../data/datasources/digest_remote_data_source.dart';
import '../../data/local/isar/isar_database.dart';
import '../../data/repositories/digest_repository_impl.dart';
import '../../domain/entities/digest.dart';
import '../../domain/entities/feedback_event.dart';
import '../../domain/entities/rule_profile.dart';
import '../../domain/repositories/digest_repository.dart';

/// Purpose: Provide current active rule profile state used by the app.
final activeRuleProfileProvider = StateProvider<RuleProfile>((ref) {
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
    updatedAt: DateTime.now().toUtc(),
  );
});

/// Purpose: Trigger digest feed refresh through integer invalidation.
final digestRefreshTickProvider = StateProvider<int>((ref) => 0);

/// Purpose: Provide repository after asynchronous Isar initialization.
final digestRepositoryProvider = FutureProvider<DigestRepository>((ref) async {
  final isar = await IsarDatabase.open();
  final remote = DigestRemoteDataSourceImpl(ref.read(dioProvider));
  final local = DigestLocalDataSourceImpl(isar);
  return DigestRepositoryImpl(remote: remote, local: local);
});

/// Purpose: Provide use case for latest digest retrieval.
final getLatestDigestUseCaseProvider = FutureProvider<GetLatestDigestUseCase>((
  ref,
) async {
  final repository = await ref.watch(digestRepositoryProvider.future);
  return GetLatestDigestUseCase(repository);
});

/// Purpose: Provide use case for digest detail retrieval.
final getDigestDetailUseCaseProvider = FutureProvider<GetDigestDetailUseCase>((
  ref,
) async {
  final repository = await ref.watch(digestRepositoryProvider.future);
  return GetDigestDetailUseCase(repository);
});

/// Purpose: Provide use case for rule profile persistence.
final saveRuleProfileUseCaseProvider = FutureProvider<SaveRuleProfileUseCase>((
  ref,
) async {
  final repository = await ref.watch(digestRepositoryProvider.future);
  return SaveRuleProfileUseCase(repository);
});

/// Purpose: Provide use case for feedback submission.
final submitFeedbackUseCaseProvider = FutureProvider<SubmitFeedbackUseCase>((
  ref,
) async {
  final repository = await ref.watch(digestRepositoryProvider.future);
  return SubmitFeedbackUseCase(repository);
});

/// Purpose: Load latest digest whenever active profile or refresh tick changes.
final latestDigestProvider = FutureProvider<Digest>((ref) async {
  ref.watch(digestRefreshTickProvider);
  final profile = ref.watch(activeRuleProfileProvider);
  final useCase = await ref.watch(getLatestDigestUseCaseProvider.future);
  return useCase.call(ruleProfileId: profile.id);
});

/// Purpose: Load digest detail by id for detail screen rendering.
final digestDetailProvider = FutureProvider.family<Digest, String>((
  ref,
  digestId,
) async {
  final useCase = await ref.watch(getDigestDetailUseCaseProvider.future);
  return useCase.call(digestId: digestId);
});

/// Purpose: Persist rule profile updates and bump refresh tick.
final saveRuleProfileControllerProvider = Provider<SaveRuleProfileController>((
  ref,
) {
  return SaveRuleProfileController(ref);
});

/// Purpose: Orchestrate rule save side effects from UI actions.
final class SaveRuleProfileController {
  /// Purpose: Construct controller with provider ref dependency.
  const SaveRuleProfileController(this._ref);

  final Ref _ref;

  /// Purpose: Save profile, update active state and refresh digest.
  Future<void> save(RuleProfile profile) async {
    final useCase = await _ref.read(saveRuleProfileUseCaseProvider.future);
    final saved = await useCase.call(profile: profile);
    _ref.read(activeRuleProfileProvider.notifier).state = saved;
    _ref.read(digestRefreshTickProvider.notifier).state++;
  }
}

/// Purpose: Submit feedback from UI screens.
final submitFeedbackControllerProvider = Provider<SubmitFeedbackController>((
  ref,
) {
  return SubmitFeedbackController(ref);
});

/// Purpose: Orchestrate feedback submission and potential refresh hooks.
final class SubmitFeedbackController {
  /// Purpose: Construct controller with provider ref dependency.
  const SubmitFeedbackController(this._ref);

  final Ref _ref;

  /// Purpose: Submit feedback event using use case dependency.
  Future<void> submit(FeedbackEvent event) async {
    final useCase = await _ref.read(submitFeedbackUseCaseProvider.future);
    await useCase.call(feedback: event);
  }
}
