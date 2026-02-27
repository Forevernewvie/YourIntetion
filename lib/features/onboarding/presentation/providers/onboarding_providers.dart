import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Purpose: Hold onboarding completion state used by route guards.
final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingStatusController, bool>(
      OnboardingStatusController.new,
    );

/// Purpose: Manage onboarding completion persistence for deterministic app entry.
class OnboardingStatusController extends AsyncNotifier<bool> {
  static const _onboardingCompletedKey = 'onboarding.completed';

  /// Purpose: Restore onboarding completion flag from local persistent storage.
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Purpose: Persist onboarding completion flag as true.
  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
    state = const AsyncData(true);
  }

  /// Purpose: Persist onboarding completion flag as false for replay flows.
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, false);
    state = const AsyncData(false);
  }
}
