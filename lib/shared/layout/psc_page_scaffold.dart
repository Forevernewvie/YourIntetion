import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../widgets/psc_blocks.dart';

/// Purpose: Standardized page scaffold for consistent title, spacing and bottom navigation.
class PscPageScaffold extends StatelessWidget {
  /// Purpose: Build page scaffold with deterministic layout slots.
  const PscPageScaffold({
    required this.title,
    required this.body,
    this.bottomNavigation,
    super.key,
  });

  final String title;
  final Widget body;
  final Widget? bottomNavigation;

  /// Purpose: Build common layout structure for all feature screens.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.secondary.withValues(alpha: 0.14),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppUiSpacing.xxl,
              AppUiSpacing.lg,
              AppUiSpacing.xxl,
              0,
            ),
            child: Column(
              children: [
                PscSurfaceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppUiSpacing.section,
                    vertical: AppUiSpacing.xxl,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppMetadata.productName,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: AppUiSpacing.xxs),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: AppUiSize.controlLg,
                        height: AppUiSize.controlLg,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(AppUiRadius.md),
                        ),
                        child: Icon(
                          Icons.auto_stories_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUiSpacing.section),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation,
    );
  }
}
