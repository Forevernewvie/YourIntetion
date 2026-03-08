import 'package:flutter/material.dart';

/// Purpose: Describe reusable hero content for auth entry and status screens.
final class AuthHeroContent {
  /// Purpose: Construct immutable hero content from editorial copy and bullet points.
  const AuthHeroContent({
    required this.eyebrow,
    required this.title,
    required this.description,
    this.points = const [],
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<AuthHeroPointContent> points;
}

/// Purpose: Describe a single bullet point inside reusable hero content.
final class AuthHeroPointContent {
  /// Purpose: Construct immutable hero bullet content from label and icon.
  const AuthHeroPointContent({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Purpose: Centralize shared auth screen copy so labels stay consistent and testable.
abstract final class AuthUiCopy {
  static const signInTitle = 'Sign In';
  static const createAccountTitle = 'Create Account';
  static const forgotPasswordTitle = 'Forgot Password';
  static const resetPasswordTitle = 'Reset Password';
  static const verifyYourEmailTitle = 'Verify Your Email';
  static const emailVerificationTitle = 'Email Verification';

  static const yourAccountSection = 'Your Account';
  static const accountDetailsSection = 'Account Details';

  static const nameLabel = 'Name';
  static const emailLabel = 'Email';
  static const emailHint = 'you@example.com';
  static const passwordLabel = 'Password';
  static const newPasswordLabel = 'New Password';
  static const confirmPasswordLabel = 'Confirm Password';
  static const resetTokenLabel = 'Reset Token';

  static const forgotPasswordAction = 'Forgot password?';
  static const signInAction = 'Sign In';
  static const createAccountAction = 'Create Account';
  static const backToSignInAction = 'Back to Sign In';
  static const sendResetLinkAction = 'Send Reset Link';
  static const resetPasswordAction = 'Reset Password';
  static const verifiedEmailAction = "I've Verified My Email";
  static const resendVerificationEmailAction = 'Resend Verification Email';
  static const continueSetupAction = 'Continue Setup';
  static const backToVerificationAction = 'Back to Verification';

  static const forgotPasswordDescription =
      'Enter your email to receive a password reset link.';
  static const resetPasswordDescription =
      'Paste your reset token and choose a new password.';
  static const verificationEmailLead = 'We sent a verification link to:';
  static const verificationRequiredDescription =
      'Verification is required before you can view personalized digests.';
  static const defaultVerificationEmail = 'your account email';
  static const verifyingEmailStatus = 'Verifying your email...';
  static const loginHero = AuthHeroContent(
    eyebrow: 'Explainable Briefing',
    title: 'Read less noise. Keep the receipts.',
    description:
        'Sign in to a digest that explains every ranking decision and traces each summary back to the underlying sources.',
    points: [
      AuthHeroPointContent(
        label: 'Every digest explains why it appears.',
        icon: Icons.tune_outlined,
      ),
      AuthHeroPointContent(
        label: 'Every summary links back to original sources.',
        icon: Icons.link_outlined,
      ),
    ],
  );
  static const signUpHero = AuthHeroContent(
    eyebrow: 'Start With Trust',
    title: 'Build a digest profile that can explain itself.',
    description:
        'Create your account first. After email verification you will set the topics, sources, and cadence that shape every brief.',
  );
  static const verificationSuccessHero = AuthHeroContent(
    eyebrow: 'Verification Complete',
    title: 'Your account is ready for guided setup.',
    description:
        'Email trust has been confirmed. You can continue to topic and source setup now.',
  );
  static const verificationFailureHero = AuthHeroContent(
    eyebrow: 'Verification Review',
    title: 'This verification link could not be completed.',
    description:
        'Try the verification flow again or request a fresh email link before continuing.',
  );

  /// Purpose: Build resend action copy from the active verification cooldown state.
  static String resendVerificationLabel(int remainingSeconds) {
    if (remainingSeconds <= 0) {
      return resendVerificationEmailAction;
    }

    return 'Resend in ${remainingSeconds}s';
  }
}
