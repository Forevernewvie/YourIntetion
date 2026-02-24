import 'package:isar/isar.dart';

part 'rule_profile_cache_entity.g.dart';

/// Purpose: Persist serialized rule profile snapshots for offline startup continuity.
@collection
class RuleProfileCacheEntity {
  /// Purpose: Isar collection primary key.
  Id id = Isar.autoIncrement;

  /// Purpose: Domain rule profile identifier.
  @Index(unique: true)
  late String profileId;

  /// Purpose: Domain profile version.
  late int version;

  /// Purpose: Serialized domain profile payload.
  late String profileJson;

  /// Purpose: Last update timestamp.
  @Index()
  late DateTime updatedAt;
}
