import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/digest/presentation/screens/digest_detail_screen.dart';
import '../../features/digest/presentation/screens/home_digest_feed_screen.dart';
import '../../features/feedback/presentation/screens/feedback_tuning_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/onboarding/presentation/screens/source_preference_screen.dart';
import '../../features/onboarding/presentation/screens/tone_frequency_screen.dart';
import '../../features/onboarding/presentation/screens/topic_selection_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/rules/presentation/screens/rule_builder_advanced_screen.dart';
import '../../features/rules/presentation/screens/rule_builder_basic_screen.dart';
import '../../features/saved/presentation/screens/saved_digests_screen.dart';
import '../../features/settings/presentation/screens/settings_privacy_screen.dart';

/// Purpose: Provide route path constants to avoid hardcoded strings.
abstract final class AppRoutePath {
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String welcome = '/welcome';
  static const String onboardingTopics = '/onboarding/topics';
  static const String onboardingSources = '/onboarding/sources';
  static const String onboardingToneFrequency = '/onboarding/tone-frequency';
  static const String home = '/home';
  static const String digestDetail = '/detail/:digestId';
  static const String rulesBasic = '/rules/basic';
  static const String rulesAdvanced = '/rules/advanced';
  static const String feedback = '/feedback';
  static const String saved = '/saved';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  /// Purpose: Build concrete digest detail path from digest identifier.
  static String digestDetailById(String digestId) => '/detail/$digestId';
}

/// Purpose: Provide app router instance configured with all feature routes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final isAuthenticated = authState.valueOrNull != null;

  return GoRouter(
    initialLocation: AppRoutePath.login,
    redirect: (_, state) {
      final path = state.uri.path;
      final isAuthRoute =
          path == AppRoutePath.login || path == AppRoutePath.signUp;

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutePath.login;
      }

      if (isAuthenticated && isAuthRoute) {
        return AppRoutePath.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutePath.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutePath.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutePath.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutePath.onboardingTopics,
        builder: (context, state) => const TopicSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutePath.onboardingSources,
        builder: (context, state) => const SourcePreferenceScreen(),
      ),
      GoRoute(
        path: AppRoutePath.onboardingToneFrequency,
        builder: (context, state) => const ToneFrequencyScreen(),
      ),
      GoRoute(
        path: AppRoutePath.home,
        builder: (context, state) => const HomeDigestFeedScreen(),
      ),
      GoRoute(
        path: AppRoutePath.digestDetail,
        builder: (_, state) {
          final digestId = state.pathParameters['digestId'] ?? 'unknown_digest';
          return DigestDetailScreen(digestId: digestId);
        },
      ),
      GoRoute(
        path: AppRoutePath.rulesBasic,
        builder: (context, state) => const RuleBuilderBasicScreen(),
      ),
      GoRoute(
        path: AppRoutePath.rulesAdvanced,
        builder: (context, state) => const RuleBuilderAdvancedScreen(),
      ),
      GoRoute(
        path: AppRoutePath.feedback,
        builder: (context, state) => const FeedbackTuningScreen(),
      ),
      GoRoute(
        path: AppRoutePath.saved,
        builder: (context, state) => const SavedDigestsScreen(),
      ),
      GoRoute(
        path: AppRoutePath.notifications,
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutePath.settings,
        builder: (context, state) => const SettingsPrivacyScreen(),
      ),
    ],
  );
});
