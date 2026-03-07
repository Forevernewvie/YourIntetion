import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/logging/app_logger.dart';

/// Purpose: Provide centralized snack-bar feedback with consistent styling and logging.
final class AppFeedbackMessenger {
  AppFeedbackMessenger._();

  /// Purpose: Show a success snack bar and emit a structured informational log.
  static void showSuccess(
    BuildContext context, {
    required String message,
    String event = 'ui_feedback_success',
    Map<String, Object?> fields = const {},
  }) {
    _show(
      context,
      message: message,
      event: event,
      fields: fields,
      type: _FeedbackType.success,
    );
  }

  /// Purpose: Show an informational snack bar and emit a structured informational log.
  static void showInfo(
    BuildContext context, {
    required String message,
    String event = 'ui_feedback_info',
    Map<String, Object?> fields = const {},
  }) {
    _show(
      context,
      message: message,
      event: event,
      fields: fields,
      type: _FeedbackType.info,
    );
  }

  /// Purpose: Show an error snack bar and emit a structured warning log.
  static void showError(
    BuildContext context, {
    required String message,
    String event = 'ui_feedback_error',
    Map<String, Object?> fields = const {},
  }) {
    _show(
      context,
      message: message,
      event: event,
      fields: fields,
      type: _FeedbackType.error,
    );
  }

  /// Purpose: Render the snack bar while avoiding duplicate presentation code in screens.
  static void _show(
    BuildContext context, {
    required String message,
    required String event,
    required Map<String, Object?> fields,
    required _FeedbackType type,
  }) {
    if (!context.mounted) {
      AppLogger.warn(
        'ui_feedback_skipped_unmounted_context',
        fields: {'event': event},
      );
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      AppLogger.warn('ui_feedback_missing_messenger', fields: {'event': event});
      return;
    }

    final theme = Theme.of(context);
    final (backgroundColor, foregroundColor) = switch (type) {
      _FeedbackType.success => (
        theme.colorScheme.primary,
        theme.colorScheme.onPrimary,
      ),
      _FeedbackType.info => (
        theme.colorScheme.secondary,
        theme.colorScheme.onSecondary,
      ),
      _FeedbackType.error => (
        theme.colorScheme.error,
        theme.colorScheme.onError,
      ),
    };

    if (type == _FeedbackType.error) {
      AppLogger.warn(event, fields: fields);
    } else {
      AppLogger.info(event, fields: fields);
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: foregroundColor),
          ),
          duration: AppUiDuration.feedback,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
        ),
      );
  }
}

/// Purpose: Enumerate supported feedback styles for deterministic snack-bar presentation.
enum _FeedbackType { success, info, error }
