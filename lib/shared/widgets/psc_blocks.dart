import 'package:flutter/material.dart';

/// Purpose: Render section title with consistent heading weight.
class PscSectionTitle extends StatelessWidget {
  /// Purpose: Construct section title with required text.
  const PscSectionTitle(this.text, {super.key});

  final String text;

  /// Purpose: Build section title text widget.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

/// Purpose: Render deterministic rule/source summary card used across screens.
class PscRuleSectionCard extends StatelessWidget {
  /// Purpose: Construct rule section card with explainable metadata.
  const PscRuleSectionCard({
    required this.title,
    required this.description,
    required this.status,
    required this.hint,
    this.statusColor,
    this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final String status;
  final String hint;
  final Color? statusColor;
  final VoidCallback? onTap;

  /// Purpose: Build bordered surface card with deterministic metadata rows.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusTextColor = statusColor ?? theme.colorScheme.primary;

    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    status,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    hint,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Purpose: Render compact row block for settings and notification state.
class PscStateRowCard extends StatelessWidget {
  /// Purpose: Construct state row card with label and value.
  const PscStateRowCard({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
    super.key,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  /// Purpose: Build row card used in notification and settings screens.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: valueColor ?? theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Purpose: Render compact status banner for warning/error messaging.
class PscStatusBanner extends StatelessWidget {
  /// Purpose: Construct status banner with semantic color and message.
  const PscStatusBanner({
    required this.message,
    required this.color,
    super.key,
  });

  final String message;
  final Color color;

  /// Purpose: Build bordered status banner.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        message,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Purpose: Render digest preview card with explainability and source metadata.
class PscDigestCard extends StatelessWidget {
  /// Purpose: Construct digest card with required deterministic digest fields.
  const PscDigestCard({
    required this.topic,
    required this.whyReason,
    required this.summary,
    required this.freshness,
    required this.sourceMix,
    super.key,
  });

  final String topic;
  final String whyReason;
  final String summary;
  final String freshness;
  final String sourceMix;

  /// Purpose: Build digest card surface matching app digest feed structure.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        color: theme.cardTheme.color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topic,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                freshness,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            whyReason,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(summary, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            sourceMix,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
