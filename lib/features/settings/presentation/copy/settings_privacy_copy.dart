/// Purpose: Centralize settings and privacy copy for consistent legal/account messaging.
abstract final class SettingsPrivacyCopy {
  static const screenTitle = 'Settings & Privacy';
  static const heroEyebrow = 'Accessible Controls';
  static const heroTitle = 'Keep trust visible, not hidden in menus.';
  static const heroDescription =
      'This area governs account state, transparency controls, and how much of the digest system remains visible and adjustable to you.';
  static const accountTitle = 'Account';
  static const accountStatus = 'Configured';
  static const accountHint = 'Profile and identity state';
  static const privacyControlsTitle = 'Privacy Controls';
  static const privacyControlsDescription =
      'Data export, account deletion, and consent history.';
  static const privacyControlsStatus = 'Transparent';
  static const privacyControlsHint = 'Designed to keep control explicit';
  static const legalSectionTitle = 'Legal & Policy';
  static const privacyPolicyTitle = 'Privacy Policy';
  static const privacyPolicyDescription =
      'Review how account details, digest preferences, saved items, and feedback data are handled.';
  static const privacyPolicyHostLabel = 'GitHub Pages';
  static const privacyPolicyUrlLabel = 'Public policy URL';
  static const privacyPolicyOpenAction = 'Open Privacy Policy';
  static const privacyPolicyHint =
      'Opens the canonical policy page in your browser.';
  static const privacyPolicyOpenFailed =
      'Unable to open the privacy policy right now.';
  static const themeLabel = 'Theme';
  static const themeValue = 'System (Light / Dark)';
  static const explainabilityLabel = 'Explainability mode';
  static const explainabilityValue = 'Always visible';
  static const privacyActionsTitle = 'Privacy Actions';
  static const exportDataAction = 'Export My Data';
  static const replayOnboardingAction = 'Replay Onboarding';
  static const deleteWarningMessage =
      'Account deletion is intentionally separated from routine actions to reduce destructive mistakes.';
  static const deleteAccountAction = 'Delete Account';
  static const signOutAction = 'Sign Out';

  /// Purpose: Build account summary text from the active signed-in email context.
  static String accountDescription(String email) {
    return '$email • locale • digest timezone';
  }
}
