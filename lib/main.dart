import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/app_env.dart';
import 'core/logging/app_logger.dart';

/// Purpose: Bootstrap the application runtime before rendering widgets.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  AppLogger.info('app_bootstrap_complete');
  runApp(const ProviderScope(child: PreferenceSummaryCuratorApp()));
}
