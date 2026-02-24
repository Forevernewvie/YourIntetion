// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_cache_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDigestCacheEntityCollection on Isar {
  IsarCollection<DigestCacheEntity> get digestCacheEntitys => this.collection();
}

const DigestCacheEntitySchema = CollectionSchema(
  name: r'DigestCacheEntity',
  id: 3185318169662826211,
  properties: {
    r'digestId': PropertySchema(
      id: 0,
      name: r'digestId',
      type: IsarType.string,
    ),
    r'digestJson': PropertySchema(
      id: 1,
      name: r'digestJson',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 2,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'generatedAt': PropertySchema(
      id: 3,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'profileId': PropertySchema(
      id: 4,
      name: r'profileId',
      type: IsarType.string,
    ),
  },
  estimateSize: _digestCacheEntityEstimateSize,
  serialize: _digestCacheEntitySerialize,
  deserialize: _digestCacheEntityDeserialize,
  deserializeProp: _digestCacheEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'digestId': IndexSchema(
      id: -6502985019431402249,
      name: r'digestId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'digestId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'profileId': IndexSchema(
      id: 6052971939042612300,
      name: r'profileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'generatedAt': IndexSchema(
      id: 4527473099475400258,
      name: r'generatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'generatedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'expiresAt': IndexSchema(
      id: 4994901953235663716,
      name: r'expiresAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expiresAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _digestCacheEntityGetId,
  getLinks: _digestCacheEntityGetLinks,
  attach: _digestCacheEntityAttach,
  version: '3.1.0+1',
);

int _digestCacheEntityEstimateSize(
  DigestCacheEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.digestId.length * 3;
  bytesCount += 3 + object.digestJson.length * 3;
  bytesCount += 3 + object.profileId.length * 3;
  return bytesCount;
}

void _digestCacheEntitySerialize(
  DigestCacheEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.digestId);
  writer.writeString(offsets[1], object.digestJson);
  writer.writeDateTime(offsets[2], object.expiresAt);
  writer.writeDateTime(offsets[3], object.generatedAt);
  writer.writeString(offsets[4], object.profileId);
}

DigestCacheEntity _digestCacheEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DigestCacheEntity();
  object.digestId = reader.readString(offsets[0]);
  object.digestJson = reader.readString(offsets[1]);
  object.expiresAt = reader.readDateTime(offsets[2]);
  object.generatedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.profileId = reader.readString(offsets[4]);
  return object;
}

P _digestCacheEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _digestCacheEntityGetId(DigestCacheEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _digestCacheEntityGetLinks(
  DigestCacheEntity object,
) {
  return [];
}

void _digestCacheEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  DigestCacheEntity object,
) {
  object.id = id;
}

extension DigestCacheEntityByIndex on IsarCollection<DigestCacheEntity> {
  Future<DigestCacheEntity?> getByDigestId(String digestId) {
    return getByIndex(r'digestId', [digestId]);
  }

  DigestCacheEntity? getByDigestIdSync(String digestId) {
    return getByIndexSync(r'digestId', [digestId]);
  }

  Future<bool> deleteByDigestId(String digestId) {
    return deleteByIndex(r'digestId', [digestId]);
  }

  bool deleteByDigestIdSync(String digestId) {
    return deleteByIndexSync(r'digestId', [digestId]);
  }

  Future<List<DigestCacheEntity?>> getAllByDigestId(
    List<String> digestIdValues,
  ) {
    final values = digestIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'digestId', values);
  }

  List<DigestCacheEntity?> getAllByDigestIdSync(List<String> digestIdValues) {
    final values = digestIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'digestId', values);
  }

  Future<int> deleteAllByDigestId(List<String> digestIdValues) {
    final values = digestIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'digestId', values);
  }

  int deleteAllByDigestIdSync(List<String> digestIdValues) {
    final values = digestIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'digestId', values);
  }

  Future<Id> putByDigestId(DigestCacheEntity object) {
    return putByIndex(r'digestId', object);
  }

  Id putByDigestIdSync(DigestCacheEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'digestId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDigestId(List<DigestCacheEntity> objects) {
    return putAllByIndex(r'digestId', objects);
  }

  List<Id> putAllByDigestIdSync(
    List<DigestCacheEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'digestId', objects, saveLinks: saveLinks);
  }
}

extension DigestCacheEntityQueryWhereSort
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QWhere> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhere>
  anyGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'generatedAt'),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhere>
  anyExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expiresAt'),
      );
    });
  }
}

extension DigestCacheEntityQueryWhere
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QWhereClause> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  digestIdEqualTo(String digestId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'digestId', value: [digestId]),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  digestIdNotEqualTo(String digestId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'digestId',
                lower: [],
                upper: [digestId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'digestId',
                lower: [digestId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'digestId',
                lower: [digestId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'digestId',
                lower: [],
                upper: [digestId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  profileIdEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'profileId', value: [profileId]),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  profileIdNotEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [],
                upper: [profileId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [profileId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [profileId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'profileId',
                lower: [],
                upper: [profileId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  generatedAtEqualTo(DateTime generatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'generatedAt',
          value: [generatedAt],
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  generatedAtNotEqualTo(DateTime generatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'generatedAt',
                lower: [],
                upper: [generatedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'generatedAt',
                lower: [generatedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'generatedAt',
                lower: [generatedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'generatedAt',
                lower: [],
                upper: [generatedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  generatedAtGreaterThan(DateTime generatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'generatedAt',
          lower: [generatedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  generatedAtLessThan(DateTime generatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'generatedAt',
          lower: [],
          upper: [generatedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  generatedAtBetween(
    DateTime lowerGeneratedAt,
    DateTime upperGeneratedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'generatedAt',
          lower: [lowerGeneratedAt],
          includeLower: includeLower,
          upper: [upperGeneratedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  expiresAtEqualTo(DateTime expiresAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'expiresAt', value: [expiresAt]),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  expiresAtNotEqualTo(DateTime expiresAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'expiresAt',
                lower: [],
                upper: [expiresAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'expiresAt',
                lower: [expiresAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'expiresAt',
                lower: [expiresAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'expiresAt',
                lower: [],
                upper: [expiresAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  expiresAtGreaterThan(DateTime expiresAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'expiresAt',
          lower: [expiresAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  expiresAtLessThan(DateTime expiresAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'expiresAt',
          lower: [],
          upper: [expiresAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterWhereClause>
  expiresAtBetween(
    DateTime lowerExpiresAt,
    DateTime upperExpiresAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'expiresAt',
          lower: [lowerExpiresAt],
          includeLower: includeLower,
          upper: [upperExpiresAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DigestCacheEntityQueryFilter
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QFilterCondition> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'digestId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'digestId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'digestId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'digestId', value: ''),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'digestId', value: ''),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'digestJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'digestJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'digestJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'digestJson', value: ''),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  digestJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'digestJson', value: ''),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  expiresAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expiresAt', value: value),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  expiresAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expiresAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  expiresAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expiresAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  expiresAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expiresAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'generatedAt', value: value),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  generatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'generatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  generatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'generatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'generatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profileId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'profileId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'profileId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profileId', value: ''),
      );
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterFilterCondition>
  profileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'profileId', value: ''),
      );
    });
  }
}

extension DigestCacheEntityQueryObject
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QFilterCondition> {}

extension DigestCacheEntityQueryLinks
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QFilterCondition> {}

extension DigestCacheEntityQuerySortBy
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QSortBy> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByDigestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestId', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByDigestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestId', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByDigestJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestJson', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByDigestJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestJson', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  sortByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }
}

extension DigestCacheEntityQuerySortThenBy
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QSortThenBy> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByDigestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestId', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByDigestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestId', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByDigestJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestJson', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByDigestJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'digestJson', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QAfterSortBy>
  thenByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }
}

extension DigestCacheEntityQueryWhereDistinct
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct> {
  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct>
  distinctByDigestId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'digestId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct>
  distinctByDigestJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'digestJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct>
  distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct>
  distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<DigestCacheEntity, DigestCacheEntity, QDistinct>
  distinctByProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileId', caseSensitive: caseSensitive);
    });
  }
}

extension DigestCacheEntityQueryProperty
    on QueryBuilder<DigestCacheEntity, DigestCacheEntity, QQueryProperty> {
  QueryBuilder<DigestCacheEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DigestCacheEntity, String, QQueryOperations> digestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'digestId');
    });
  }

  QueryBuilder<DigestCacheEntity, String, QQueryOperations>
  digestJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'digestJson');
    });
  }

  QueryBuilder<DigestCacheEntity, DateTime, QQueryOperations>
  expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<DigestCacheEntity, DateTime, QQueryOperations>
  generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<DigestCacheEntity, String, QQueryOperations>
  profileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileId');
    });
  }
}
