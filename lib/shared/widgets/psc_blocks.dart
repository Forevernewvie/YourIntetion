import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

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
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        letterSpacing: 0.3,
      ),
    );
  }
}

/// Purpose: Render a reusable editorial-style surface card.
class PscSurfaceCard extends StatelessWidget {
  /// Purpose: Construct a padded card surface.
  const PscSurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppUiSpacing.card),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.radius = AppUiRadius.xxl,
    this.emphasize = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double radius;
  final bool emphasize;

  /// Purpose: Build the shared card container with optional tap behavior.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBackground =
        backgroundColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final resolvedBorder =
        borderColor ??
        theme.dividerColor.withValues(alpha: emphasize ? 0.7 : 0.5);
    final decoration = BoxDecoration(
      color: resolvedBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: resolvedBorder),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: emphasize ? 0.16 : 0.08),
          blurRadius: emphasize ? 30 : AppUiSpacing.card,
          offset: const Offset(0, AppUiSpacing.md),
        ),
      ],
    );

    final content = Padding(padding: padding, child: child);
    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }
}

/// Purpose: Render compact metadata pill for emphasis, metrics, and status.
class PscInfoPill extends StatelessWidget {
  /// Purpose: Construct an editorial chip with optional icon.
  const PscInfoPill({
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  /// Purpose: Build the compact metadata chip.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedForeground = foregroundColor ?? theme.colorScheme.primary;
    final resolvedBackground =
        backgroundColor ?? resolvedForeground.withValues(alpha: 0.12);
    final maxWidth =
        (MediaQuery.sizeOf(context).width - AppUiSize.pillMaxWidthInset).clamp(
          AppUiSize.pillMinWidth,
          AppUiSize.pillMaxWidth,
        );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: AppUiSpacing.lg,
              vertical: AppUiSpacing.sm,
            ),
        decoration: BoxDecoration(
          color: resolvedBackground,
          borderRadius: BorderRadius.circular(AppUiRadius.pill),
          border: Border.all(color: resolvedForeground.withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppUiSize.iconXs, color: resolvedForeground),
              const SizedBox(width: AppUiSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: resolvedForeground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render a step-aware header for onboarding flows.
class PscStepHeader extends StatelessWidget {
  /// Purpose: Construct onboarding step header.
  const PscStepHeader({
    required this.step,
    required this.totalSteps,
    required this.title,
    required this.description,
    this.tags = const [],
    super.key,
  });

  final int step;
  final int totalSteps;
  final String title;
  final String description;
  final List<String> tags;

  /// Purpose: Build the step header with progress and helper tags.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscSurfaceCard(
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppUiSpacing.sm,
            runSpacing: AppUiSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PscInfoPill(
                label: 'Step $step of $totalSteps',
                icon: Icons.auto_awesome_motion_outlined,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: AppUiSpacing.sm,
                ),
                child: Text(
                  'Editable later',
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppUiSpacing.xxl),
          Row(
            children: List.generate(totalSteps, (index) {
              final active = index < step;
              return Expanded(
                child: Container(
                  height: AppUiSize.stepProgressHeight,
                  margin: EdgeInsets.only(
                    right: index == totalSteps - 1 ? 0 : AppUiSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppUiRadius.pill),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppUiSpacing.section),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppUiSpacing.sm),
          Text(description, style: theme.textTheme.bodyMedium),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: AppUiSpacing.xxl),
            Wrap(
              spacing: AppUiSpacing.sm,
              runSpacing: AppUiSpacing.sm,
              children: tags
                  .map(
                    (tag) => PscInfoPill(
                      label: tag,
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.16,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

/// Purpose: Render concise bullet rows for product promises and tips.
class PscBulletLine extends StatelessWidget {
  /// Purpose: Construct a line item with leading icon.
  const PscBulletLine({required this.label, this.icon, super.key});

  final String label;
  final IconData? icon;

  /// Purpose: Build the bullet line.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon ?? Icons.done_rounded,
          size: AppUiSize.iconSm,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppUiSpacing.md),
        Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
      ],
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

    return PscSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppUiSpacing.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PscInfoPill(
                  label: status,
                  backgroundColor: statusTextColor.withValues(alpha: 0.12),
                  foregroundColor: statusTextColor,
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_outward_rounded,
                  size: AppUiSize.iconMd,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
          const SizedBox(height: AppUiSpacing.xl),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppUiSpacing.xs),
          Text(description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppUiSpacing.lg),
          Text(
            hint,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
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

    return PscSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppUiSpacing.section,
        vertical: AppUiSpacing.xxl,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppUiSpacing.lg),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: theme.textTheme.labelLarge?.copyWith(
                color: valueColor ?? theme.colorScheme.primary,
              ),
            ),
          ),
        ],
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
    return PscSurfaceCard(
      backgroundColor: color.withValues(alpha: 0.08),
      borderColor: color.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(
        horizontal: AppUiSpacing.xxl,
        vertical: AppUiSpacing.xl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color,
            size: AppUiSize.iconMd,
          ),
          const SizedBox(width: AppUiSpacing.md),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppUiSpacing.sm,
            runSpacing: AppUiSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const PscInfoPill(
                label: 'Preview Brief',
                icon: Icons.menu_book_outlined,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: AppUiSpacing.sm,
                ),
                child: Text(freshness, style: theme.textTheme.labelMedium),
              ),
            ],
          ),
          const SizedBox(height: AppUiSpacing.xxl),
          Text(topic, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppUiSpacing.sm),
          Text(
            whyReason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppUiSpacing.lg),
          Text(summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppUiSpacing.xxl),
          PscInfoPill(
            label: sourceMix,
            icon: Icons.link_outlined,
            backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.1),
            foregroundColor: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
