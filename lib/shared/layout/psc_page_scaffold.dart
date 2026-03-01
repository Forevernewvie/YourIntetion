import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.menu, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation,
    );
  }
}
