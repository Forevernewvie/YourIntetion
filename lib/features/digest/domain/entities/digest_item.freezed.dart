// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digest_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DigestItem _$DigestItemFromJson(Map<String, dynamic> json) {
  return _DigestItem.fromJson(json);
}

/// @nodoc
mixin _$DigestItem {
  String get id => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get whyReason => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  int get freshnessMinutes => throw _privateConstructorUsedError;
  List<Citation> get citations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DigestItemCopyWith<DigestItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DigestItemCopyWith<$Res> {
  factory $DigestItemCopyWith(
    DigestItem value,
    $Res Function(DigestItem) then,
  ) = _$DigestItemCopyWithImpl<$Res, DigestItem>;
  @useResult
  $Res call({
    String id,
    String topic,
    String whyReason,
    String summary,
    int freshnessMinutes,
    List<Citation> citations,
  });
}

/// @nodoc
class _$DigestItemCopyWithImpl<$Res, $Val extends DigestItem>
    implements $DigestItemCopyWith<$Res> {
  _$DigestItemCopyWithImpl(this._value, this._then);

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
                      as List<Citation>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DigestItemImplCopyWith<$Res>
    implements $DigestItemCopyWith<$Res> {
  factory _$$DigestItemImplCopyWith(
    _$DigestItemImpl value,
    $Res Function(_$DigestItemImpl) then,
  ) = __$$DigestItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topic,
    String whyReason,
    String summary,
    int freshnessMinutes,
    List<Citation> citations,
  });
}

/// @nodoc
class __$$DigestItemImplCopyWithImpl<$Res>
    extends _$DigestItemCopyWithImpl<$Res, _$DigestItemImpl>
    implements _$$DigestItemImplCopyWith<$Res> {
  __$$DigestItemImplCopyWithImpl(
    _$DigestItemImpl _value,
    $Res Function(_$DigestItemImpl) _then,
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
      _$DigestItemImpl(
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
                  as List<Citation>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DigestItemImpl implements _DigestItem {
  const _$DigestItemImpl({
    required this.id,
    required this.topic,
    required this.whyReason,
    required this.summary,
    required this.freshnessMinutes,
    required final List<Citation> citations,
  }) : _citations = citations;

  factory _$DigestItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DigestItemImplFromJson(json);

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
  final List<Citation> _citations;
  @override
  List<Citation> get citations {
    if (_citations is EqualUnmodifiableListView) return _citations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_citations);
  }

  @override
  String toString() {
    return 'DigestItem(id: $id, topic: $topic, whyReason: $whyReason, summary: $summary, freshnessMinutes: $freshnessMinutes, citations: $citations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DigestItemImpl &&
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
  _$$DigestItemImplCopyWith<_$DigestItemImpl> get copyWith =>
      __$$DigestItemImplCopyWithImpl<_$DigestItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DigestItemImplToJson(this);
  }
}

abstract class _DigestItem implements DigestItem {
  const factory _DigestItem({
    required final String id,
    required final String topic,
    required final String whyReason,
    required final String summary,
    required final int freshnessMinutes,
    required final List<Citation> citations,
  }) = _$DigestItemImpl;

  factory _DigestItem.fromJson(Map<String, dynamic> json) =
      _$DigestItemImpl.fromJson;

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
  List<Citation> get citations;
  @override
  @JsonKey(ignore: true)
  _$$DigestItemImplCopyWith<_$DigestItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
