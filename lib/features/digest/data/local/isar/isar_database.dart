import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'digest_cache_entity.dart';
import 'rule_profile_cache_entity.dart';

/// Purpose: Manage Isar instance lifecycle for local digest persistence.
final class IsarDatabase {
  IsarDatabase._();

  static Isar? _instance;

  /// Purpose: Open and cache a single Isar instance.
  static Future<Isar> open() async {
    if (_instance != null) {
      return _instance!;
    }

    final directory = await getApplicationDocumentsDirectory();

    _instance = await Isar.open(
      [RuleProfileCacheEntitySchema, DigestCacheEntitySchema],
      directory: directory.path,
      name: 'psc_cache',
    );

    return _instance!;
  }
}
