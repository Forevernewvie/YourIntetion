// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digest_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DigestResponseDto _$DigestResponseDtoFromJson(Map<String, dynamic> json) {
  return _DigestResponseDto.fromJson(json);
}

/// @nodoc
mixin _$DigestResponseDto {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  double get qualityScore => throw _privateConstructorUsedError;
  List<DigestItemDto> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DigestResponseDtoCopyWith<DigestResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DigestResponseDtoCopyWith<$Res> {
  factory $DigestResponseDtoCopyWith(
    DigestResponseDto value,
    $Res Function(DigestResponseDto) then,
  ) = _$DigestResponseDtoCopyWithImpl<$Res, DigestResponseDto>;
  @useResult
  $Res call({
    String id,
    String profileId,
    DateTime generatedAt,
    double qualityScore,
    List<DigestItemDto> items,
  });
}

/// @nodoc
class _$DigestResponseDtoCopyWithImpl<$Res, $Val extends DigestResponseDto>
    implements $DigestResponseDtoCopyWith<$Res> {
  _$DigestResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? generatedAt = null,
    Object? qualityScore = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            qualityScore: null == qualityScore
                ? _value.qualityScore
                : qualityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<DigestItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DigestResponseDtoImplCopyWith<$Res>
    implements $DigestResponseDtoCopyWith<$Res> {
  factory _$$DigestResponseDtoImplCopyWith(
    _$DigestResponseDtoImpl value,
    $Res Function(_$DigestResponseDtoImpl) then,
  ) = __$$DigestResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    DateTime generatedAt,
    double qualityScore,
    List<DigestItemDto> items,
  });
}

/// @nodoc
class __$$DigestResponseDtoImplCopyWithImpl<$Res>
    extends _$DigestResponseDtoCopyWithImpl<$Res, _$DigestResponseDtoImpl>
    implements _$$DigestResponseDtoImplCopyWith<$Res> {
  __$$DigestResponseDtoImplCopyWithImpl(
    _$DigestResponseDtoImpl _value,
    $Res Function(_$DigestResponseDtoImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? generatedAt = null,
    Object? qualityScore = null,
    Object? items = null,
  }) {
    return _then(
      _$DigestResponseDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        qualityScore: null == qualityScore
            ? _value.qualityScore
            : qualityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<DigestItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DigestResponseDtoImpl implements _DigestResponseDto {
  const _$DigestResponseDtoImpl({
    required this.id,
    required this.profileId,
    required this.generatedAt,
    required this.qualityScore,
    required final List<DigestItemDto> items,
  }) : _items = items;

  factory _$DigestResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DigestResponseDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String profileId;
  @override
  final DateTime generatedAt;
  @override
  final double qualityScore;
  final List<DigestItemDto> _items;
  @override
  List<DigestItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'DigestResponseDto(id: $id, profileId: $profileId, generatedAt: $generatedAt, qualityScore: $qualityScore, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DigestResponseDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profileId,
    generatedAt,
    qualityScore,
    const DeepCollectionEquality().hash(_items),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DigestResponseDtoImplCopyWith<_$DigestResponseDtoImpl> get copyWith =>
      __$$DigestResponseDtoImplCopyWithImpl<_$DigestResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DigestResponseDtoImplToJson(this);
  }
}

abstract class _DigestResponseDto implements DigestResponseDto {
  const factory _DigestResponseDto({
    required final String id,
    required final String profileId,
    required final DateTime generatedAt,
    required final double qualityScore,
    required final List<DigestItemDto> items,
  }) = _$DigestResponseDtoImpl;

  factory _DigestResponseDto.fromJson(Map<String, dynamic> json) =
      _$DigestResponseDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get profileId;
  @override
  DateTime get generatedAt;
  @override
  double get qualityScore;
  @override
  List<DigestItemDto> get items;
  @override
  @JsonKey(ignore: true)
  _$$DigestResponseDtoImplCopyWith<_$DigestResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DigestItemDto _$DigestItemDtoFromJson(Map<String, dynamic> json) {
  return _DigestItemDto.fromJson(json);
}

/// @nodoc
mixin _$DigestItemDto {
  String get id => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get whyReason => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  int get freshnessMinutes => throw _privateConstructorUsedError;
  List<CitationDto> get citations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DigestItemDtoCopyWith<DigestItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DigestItemDtoCopyWith<$Res> {
  factory $DigestItemDtoCopyWith(
    DigestItemDto value,
    $Res Function(DigestItemDto) then,
  ) = _$DigestItemDtoCopyWithImpl<$Res, DigestItemDto>;
  @useResult
  $Res call({
    String id,
    String topic,
    String whyReason,
    String summary,
    int freshnessMinutes,
    List<CitationDto> citations,
  });
}

/// @nodoc
class _$DigestItemDtoCopyWithImpl<$Res, $Val extends DigestItemDto>
    implements $DigestItemDtoCopyWith<$Res> {
  _$DigestItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? whyReason = null,
    Object? summary = null,
    Object? freshnessMinutes = null,
    Object? citations = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            whyReason: null == whyReason
                ? _value.whyReason
                : whyReason // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            freshnessMinutes: null == freshnessMinutes
                ? _value.freshnessMinutes
                : freshnessMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            citations: null == citations
                ? _value.citations
                : citations // ignore: cast_nullable_to_non_nullable
                      as List<CitationDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DigestItemDtoImplCopyWith<$Res>
    implements $DigestItemDtoCopyWith<$Res> {
  factory _$$DigestItemDtoImplCopyWith(
    _$DigestItemDtoImpl value,
    $Res Function(_$DigestItemDtoImpl) then,
  ) = __$$DigestItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topic,
    String whyReason,
    String summary,
    int freshnessMinutes,
    List<CitationDto> citations,
  });
}

/// @nodoc
class __$$DigestItemDtoImplCopyWithImpl<$Res>
    extends _$DigestItemDtoCopyWithImpl<$Res, _$DigestItemDtoImpl>
    implements _$$DigestItemDtoImplCopyWith<$Res> {
  __$$DigestItemDtoImplCopyWithImpl(
    _$DigestItemDtoImpl _value,
    $Res Function(_$DigestItemDtoImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? whyReason = null,
    Object? summary = null,
    Object? freshnessMinutes = null,
    Object? citations = null,
  }) {
    return _then(
      _$DigestItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        whyReason: null == whyReason
            ? _value.whyReason
            : whyReason // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        freshnessMinutes: null == freshnessMinutes
            ? _value.freshnessMinutes
            : freshnessMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        citations: null == citations
            ? _value._citations
            : citations // ignore: cast_nullable_to_non_nullable
                  as List<CitationDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DigestItemDtoImpl implements _DigestItemDto {
  const _$DigestItemDtoImpl({
    required this.id,
    required this.topic,
    required this.whyReason,
    required this.summary,
    required this.freshnessMinutes,
    required final List<CitationDto> citations,
  }) : _citations = citations;

  factory _$DigestItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DigestItemDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String topic;
  @override
  final String whyReason;
  @override
  final String summary;
  @override
  final int freshnessMinutes;
  final List<CitationDto> _citations;
  @override
  List<CitationDto> get citations {
    if (_citations is EqualUnmodifiableListView) return _citations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_citations);
  }

  @override
  String toString() {
    return 'DigestItemDto(id: $id, topic: $topic, whyReason: $whyReason, summary: $summary, freshnessMinutes: $freshnessMinutes, citations: $citations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DigestItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.whyReason, whyReason) ||
                other.whyReason == whyReason) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.freshnessMinutes, freshnessMinutes) ||
                other.freshnessMinutes == freshnessMinutes) &&
            const DeepCollectionEquality().equals(
              other._citations,
              _citations,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    topic,
    whyReason,
    summary,
    freshnessMinutes,
    const DeepCollectionEquality().hash(_citations),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DigestItemDtoImplCopyWith<_$DigestItemDtoImpl> get copyWith =>
      __$$DigestItemDtoImplCopyWithImpl<_$DigestItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DigestItemDtoImplToJson(this);
  }
}

abstract class _DigestItemDto implements DigestItemDto {
  const factory _DigestItemDto({
    required final String id,
    required final String topic,
    required final String whyReason,
    required final String summary,
    required final int freshnessMinutes,
    required final List<CitationDto> citations,
  }) = _$DigestItemDtoImpl;

  factory _DigestItemDto.fromJson(Map<String, dynamic> json) =
      _$DigestItemDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get topic;
  @override
  String get whyReason;
  @override
  String get summary;
  @override
  int get freshnessMinutes;
  @override
  List<CitationDto> get citations;
  @override
  @JsonKey(ignore: true)
  _$$DigestItemDtoImplCopyWith<_$DigestItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CitationDto _$CitationDtoFromJson(Map<String, dynamic> json) {
  return _CitationDto.fromJson(json);
}

/// @nodoc
mixin _$CitationDto {
  String get id => throw _privateConstructorUsedError;
  String get sourceName => throw _privateConstructorUsedError;
  Uri get canonicalUrl => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CitationDtoCopyWith<CitationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CitationDtoCopyWith<$Res> {
  factory $CitationDtoCopyWith(
    CitationDto value,
    $Res Function(CitationDto) then,
  ) = _$CitationDtoCopyWithImpl<$Res, CitationDto>;
  @useResult
  $Res call({
    String id,
    String sourceName,
    Uri canonicalUrl,
    DateTime publishedAt,
  });
}

/// @nodoc
class _$CitationDtoCopyWithImpl<$Res, $Val extends CitationDto>
    implements $CitationDtoCopyWith<$Res> {
  _$CitationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceName = null,
    Object? canonicalUrl = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceName: null == sourceName
                ? _value.sourceName
                : sourceName // ignore: cast_nullable_to_non_nullable
                      as String,
            canonicalUrl: null == canonicalUrl
                ? _value.canonicalUrl
                : canonicalUrl // ignore: cast_nullable_to_non_nullable
                      as Uri,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CitationDtoImplCopyWith<$Res>
    implements $CitationDtoCopyWith<$Res> {
  factory _$$CitationDtoImplCopyWith(
    _$CitationDtoImpl value,
    $Res Function(_$CitationDtoImpl) then,
  ) = __$$CitationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sourceName,
    Uri canonicalUrl,
    DateTime publishedAt,
  });
}

/// @nodoc
class __$$CitationDtoImplCopyWithImpl<$Res>
    extends _$CitationDtoCopyWithImpl<$Res, _$CitationDtoImpl>
    implements _$$CitationDtoImplCopyWith<$Res> {
  __$$CitationDtoImplCopyWithImpl(
    _$CitationDtoImpl _value,
    $Res Function(_$CitationDtoImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceName = null,
    Object? canonicalUrl = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _$CitationDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceName: null == sourceName
            ? _value.sourceName
            : sourceName // ignore: cast_nullable_to_non_nullable
                  as String,
        canonicalUrl: null == canonicalUrl
            ? _value.canonicalUrl
            : canonicalUrl // ignore: cast_nullable_to_non_nullable
                  as Uri,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CitationDtoImpl implements _CitationDto {
  const _$CitationDtoImpl({
    required this.id,
    required this.sourceName,
    required this.canonicalUrl,
    required this.publishedAt,
  });

  factory _$CitationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CitationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String sourceName;
  @override
  final Uri canonicalUrl;
  @override
  final DateTime publishedAt;

  @override
  String toString() {
    return 'CitationDto(id: $id, sourceName: $sourceName, canonicalUrl: $canonicalUrl, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CitationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceName, sourceName) ||
                other.sourceName == sourceName) &&
            (identical(other.canonicalUrl, canonicalUrl) ||
                other.canonicalUrl == canonicalUrl) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sourceName, canonicalUrl, publishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CitationDtoImplCopyWith<_$CitationDtoImpl> get copyWith =>
      __$$CitationDtoImplCopyWithImpl<_$CitationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CitationDtoImplToJson(this);
  }
}

abstract class _CitationDto implements CitationDto {
  const factory _CitationDto({
    required final String id,
    required final String sourceName,
    required final Uri canonicalUrl,
    required final DateTime publishedAt,
  }) = _$CitationDtoImpl;

  factory _CitationDto.fromJson(Map<String, dynamic> json) =
      _$CitationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get sourceName;
  @override
  Uri get canonicalUrl;
  @override
  DateTime get publishedAt;
  @override
  @JsonKey(ignore: true)
  _$$CitationDtoImplCopyWith<_$CitationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
