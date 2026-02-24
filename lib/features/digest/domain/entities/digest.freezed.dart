// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Digest _$DigestFromJson(Map<String, dynamic> json) {
  return _Digest.fromJson(json);
}

/// @nodoc
mixin _$Digest {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  double get qualityScore => throw _privateConstructorUsedError;
  List<DigestItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DigestCopyWith<Digest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DigestCopyWith<$Res> {
  factory $DigestCopyWith(Digest value, $Res Function(Digest) then) =
      _$DigestCopyWithImpl<$Res, Digest>;
  @useResult
  $Res call({
    String id,
    String profileId,
    DateTime generatedAt,
    double qualityScore,
    List<DigestItem> items,
  });
}

/// @nodoc
class _$DigestCopyWithImpl<$Res, $Val extends Digest>
    implements $DigestCopyWith<$Res> {
  _$DigestCopyWithImpl(this._value, this._then);

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
                      as List<DigestItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DigestImplCopyWith<$Res> implements $DigestCopyWith<$Res> {
  factory _$$DigestImplCopyWith(
    _$DigestImpl value,
    $Res Function(_$DigestImpl) then,
  ) = __$$DigestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String profileId,
    DateTime generatedAt,
    double qualityScore,
    List<DigestItem> items,
  });
}

/// @nodoc
class __$$DigestImplCopyWithImpl<$Res>
    extends _$DigestCopyWithImpl<$Res, _$DigestImpl>
    implements _$$DigestImplCopyWith<$Res> {
  __$$DigestImplCopyWithImpl(
    _$DigestImpl _value,
    $Res Function(_$DigestImpl) _then,
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
      _$DigestImpl(
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
                  as List<DigestItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DigestImpl implements _Digest {
  const _$DigestImpl({
    required this.id,
    required this.profileId,
    required this.generatedAt,
    required this.qualityScore,
    required final List<DigestItem> items,
  }) : _items = items;

  factory _$DigestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DigestImplFromJson(json);

  @override
  final String id;
  @override
  final String profileId;
  @override
  final DateTime generatedAt;
  @override
  final double qualityScore;
  final List<DigestItem> _items;
  @override
  List<DigestItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Digest(id: $id, profileId: $profileId, generatedAt: $generatedAt, qualityScore: $qualityScore, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DigestImpl &&
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
  _$$DigestImplCopyWith<_$DigestImpl> get copyWith =>
      __$$DigestImplCopyWithImpl<_$DigestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DigestImplToJson(this);
  }
}

abstract class _Digest implements Digest {
  const factory _Digest({
    required final String id,
    required final String profileId,
    required final DateTime generatedAt,
    required final double qualityScore,
    required final List<DigestItem> items,
  }) = _$DigestImpl;

  factory _Digest.fromJson(Map<String, dynamic> json) = _$DigestImpl.fromJson;

  @override
  String get id;
  @override
  String get profileId;
  @override
  DateTime get generatedAt;
  @override
  double get qualityScore;
  @override
  List<DigestItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$DigestImplCopyWith<_$DigestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
