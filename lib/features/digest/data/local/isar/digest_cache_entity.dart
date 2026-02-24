import 'package:isar/isar.dart';

part 'digest_cache_entity.g.dart';

/// Purpose: Persist serialized digest snapshots with TTL metadata.
@collection
class DigestCacheEntity {
  /// Purpose: Isar collection primary key.
  Id id = Isar.autoIncrement;

  /// Purpose: Digest identifier.
  @Index(unique: true)
  late String digestId;

  /// Purpose: Rule profile identifier for lookup by profile.
  @Index()
  late String profileId;

  /// Purpose: Serialized digest payload.
  late String digestJson;

  /// Purpose: Digest generation timestamp.
  @Index()
  late DateTime generatedAt;

  /// Purpose: Expiration timestamp for cache validity checks.
  @Index()
  late DateTime expiresAt;
}
