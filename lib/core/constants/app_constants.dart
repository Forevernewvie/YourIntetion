/// Purpose: Centralized constants used across layers to avoid magic numbers.
abstract final class AppConstants {
  static const apiConnectTimeout = Duration(seconds: 5);
  static const apiReceiveTimeout = Duration(seconds: 12);
  static const retryMaxAttempts = 3;
  static const retryBaseDelay = Duration(milliseconds: 250);

  static const digestQuickMaxItems = 5;
  static const digestStandardMaxItems = 10;
  static const digestDeepMaxItems = 15;

  static const cacheDigestTtlMinutes = 1440;
  static const remoteLatestDigestMemoryTtl = Duration(seconds: 20);
}

/// Purpose: Centralize app identity strings to avoid repeated hardcoded names.
abstract final class AppMetadata {
  static const productName = 'VibeCodingExpert';
  static const windowTitle = 'Preference Summary Curator';
  static const loggerName = 'psc';
}

/// Purpose: Centralize public legal URLs so policy links stay consistent across app surfaces.
abstract final class AppLegalUrl {
  static const privacyPolicy =
      'https://forevernewvie.github.io/YourIntetion/privacy-policy/';

  /// Purpose: Parse the canonical privacy policy URL for link launching.
  static Uri get privacyPolicyUri => Uri.parse(privacyPolicy);
}

/// Purpose: Centralize API host defaults so environment resolution stays testable.
abstract final class AppNetworkDefaults {
  static const localPort = 8090;
  static const localhost = '127.0.0.1';
  static const androidEmulatorHost = '10.0.2.2';

  /// Purpose: Build a loopback-style API endpoint for local environments.
  static Uri localApiUri({required String host}) {
    return Uri(scheme: 'http', host: host, port: localPort);
  }
}

/// Purpose: Centralize network metadata keys to avoid repeated string literals.
abstract final class AppNetworkKey {
  static const authorizationHeader = 'Authorization';
  static const retryAttempt = 'retryAttempt';
}

/// Purpose: Centralize network protocol values to avoid repeated literals.
abstract final class AppNetworkValue {
  static const bearerScheme = 'Bearer';
}

/// Purpose: Centralize UI spacing tokens to improve consistency and maintainability.
abstract final class AppUiSpacing {
  static const xxs = 4.0;
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 10.0;
  static const lg = 12.0;
  static const xl = 14.0;
  static const xxl = 16.0;
  static const section = 18.0;
  static const card = 20.0;
  static const page = 24.0;
}

/// Purpose: Centralize UI size tokens to reduce repeated measurements.
abstract final class AppUiSize {
  static const iconXs = 14.0;
  static const iconSm = 16.0;
  static const iconMd = 18.0;
  static const iconLg = 20.0;
  static const controlSm = 36.0;
  static const controlLg = 42.0;
  static const searchFieldMinWidth = 48.0;
  static const feedbackSpinner = 20.0;
  static const stepProgressHeight = 5.0;
  static const pillMaxWidthInset = 72.0;
  static const pillMinWidth = 120.0;
  static const pillMaxWidth = 280.0;
}

/// Purpose: Centralize border radii to keep surfaces visually consistent.
abstract final class AppUiRadius {
  static const sm = 12.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const nav = 26.0;
  static const pill = 999.0;
}

/// Purpose: Centralize animation and timing values for deterministic UI behavior.
abstract final class AppUiDuration {
  static const fast = Duration(milliseconds: 180);
  static const feedback = Duration(seconds: 2);
  static const oneSecond = Duration(seconds: 1);
}

/// Purpose: Centralize structured log event names for cross-layer consistency.
abstract final class AppLogEvent {
  static const httpRequest = 'http_request';
  static const httpResponse = 'http_response';
  static const httpError = 'http_error';
}

/// Purpose: Centralize common feedback text for reuse and easier testing.
abstract final class AppFeedbackMessage {
  static const basicRulesSaved = 'Basic rules saved.';
  static const feedbackSubmitted = 'Feedback submitted.';
  static const notificationPermissionRequested = 'Permission check requested.';
  static const notificationRulesSaved = 'Notification rules saved.';
}

/// Purpose: Centralize auth-related policy values for validation and cooldown flows.
abstract final class AppAuthPolicy {
  static const minPasswordLength = 8;
  static const resendCooldownSeconds = 60;
}

/// Purpose: Centralize onboarding policy values to avoid repeated setup magic numbers.
abstract final class AppOnboardingPolicy {
  static const totalSteps = 4;
  static const maxTopicSelections = 8;
  static const defaultNewsSourceWeight = 70;
  static const defaultVideoSourceWeight = 20;
  static const defaultCommunitySourceWeight = 10;
}

/// Purpose: Centralize auth UI copy used across validation and status states.
abstract final class AppAuthMessage {
  static const invalidEmail = 'Enter a valid email address.';
  static const nameRequired = 'Name is required.';
  static const passwordTooShort = 'Password must be at least 8 characters.';
  static const passwordConfirmationMismatch =
      'Password confirmation does not match.';
  static const authTimeout = 'Network timeout while authenticating.';
  static const signInFailed =
      'Failed to sign in. Please check your credentials.';
  static const signUpFailed = 'Failed to create account. Please retry.';
  static const authFailedRetry = 'Authentication request failed. Please retry.';
  static const accountCreationFailedRetry =
      'Account creation failed. Please retry.';
  static const authUnauthorized = 'Authentication failed.';
  static const authTooManyRequests =
      'Too many requests. Please wait and try again.';
  static const verificationTokenMissing =
      'Verification link is missing a token.';
  static const verificationSucceeded =
      'Email verified successfully. You can continue setup.';
  static const verificationInvalidOrExpired =
      'Verification link is invalid or expired.';
  static const sessionRefreshFailed = 'Unable to refresh session.';
  static const passwordResetRequestFailed =
      'Unable to request password reset. Please retry.';
  static const passwordResetRequestSubmitted =
      'If this account exists, reset instructions were sent to your email.';
  static const resetTokenRequired = 'Reset token is required.';
  static const passwordResetInvalidOrExpired =
      'Reset link is invalid or expired.';
  static const passwordResetComplete =
      'Password reset complete. Please sign in with your new password.';
  static const passwordResetFailed = 'Unable to reset password. Please retry.';
  static const verificationEmailMissing =
      'Unable to determine account email. Please sign in again.';
  static const verificationEmailSent =
      'Verification email sent. Please check your inbox.';
  static const verificationSendFailed =
      'Unable to send verification email. Please retry.';
  static const verificationStillPending =
      'Verification is still pending. Please verify and retry.';
  static const verificationStatusRefreshFailed =
      'Failed to refresh verification status.';
}

/// Purpose: Centralize auth log event identifiers for consistent telemetry queries.
abstract final class AppAuthLogEvent {
  static const bootstrapSession = 'auth_bootstrap_session';
  static const signInRequested = 'auth_sign_in_requested';
  static const signInSucceeded = 'auth_sign_in_succeeded';
  static const signInFailed = 'auth_sign_in_failed';
  static const signUpRequested = 'auth_sign_up_requested';
  static const signUpSucceeded = 'auth_sign_up_succeeded';
  static const signUpFailed = 'auth_sign_up_failed';
  static const verificationResendMissingEmail =
      'auth_verification_resend_missing_email';
  static const verificationResendFailed = 'auth_verification_resend_failed';
  static const verificationRefreshFailed = 'auth_verification_refresh_failed';
  static const verificationTokenResolutionFailed =
      'auth_verification_token_resolution_failed';
  static const passwordResetRequestFailed =
      'auth_password_reset_request_failed';
  static const passwordResetConfirmFailed =
      'auth_password_reset_confirm_failed';
}
