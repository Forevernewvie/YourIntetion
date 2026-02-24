import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Purpose: Provide root MaterialApp configuration.
class PreferenceSummaryCuratorApp extends ConsumerWidget {
  /// Purpose: Create the root app widget.
  const PreferenceSummaryCuratorApp({super.key});

  /// Purpose: Build MaterialApp with routing and themes.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    AppLogger.info('app_build_root');

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Preference Summary Curator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
