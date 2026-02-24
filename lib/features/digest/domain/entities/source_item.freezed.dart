// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SourceItem _$SourceItemFromJson(Map<String, dynamic> json) {
  return _SourceItem.fromJson(json);
}

/// @nodoc
mixin _$SourceItem {
  String get id => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get sourceDomain => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;
  List<Citation> get citations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SourceItemCopyWith<SourceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceItemCopyWith<$Res> {
  factory $SourceItemCopyWith(
    SourceItem value,
    $Res Function(SourceItem) then,
  ) = _$SourceItemCopyWithImpl<$Res, SourceItem>;
  @useResult
  $Res call({
    String id,
    String topic,
    String category,
    String sourceDomain,
    String title,
    String body,
    DateTime publishedAt,
    List<Citation> citations,
  });
}

/// @nodoc
class _$SourceItemCopyWithImpl<$Res, $Val extends SourceItem>
    implements $SourceItemCopyWith<$Res> {
  _$SourceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? category = null,
    Object? sourceDomain = null,
    Object? title = null,
    Object? body = null,
    Object? publishedAt = null,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceDomain: null == sourceDomain
                ? _value.sourceDomain
                : sourceDomain // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$SourceItemImplCopyWith<$Res>
    implements $SourceItemCopyWith<$Res> {
  factory _$$SourceItemImplCopyWith(
    _$SourceItemImpl value,
    $Res Function(_$SourceItemImpl) then,
  ) = __$$SourceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topic,
    String category,
    String sourceDomain,
    String title,
    String body,
    DateTime publishedAt,
    List<Citation> citations,
  });
}

/// @nodoc
class __$$SourceItemImplCopyWithImpl<$Res>
    extends _$SourceItemCopyWithImpl<$Res, _$SourceItemImpl>
    implements _$$SourceItemImplCopyWith<$Res> {
  __$$SourceItemImplCopyWithImpl(
    _$SourceItemImpl _value,
    $Res Function(_$SourceItemImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topic = null,
    Object? category = null,
    Object? sourceDomain = null,
    Object? title = null,
    Object? body = null,
    Object? publishedAt = null,
    Object? citations = null,
  }) {
    return _then(
      _$SourceItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceDomain: null == sourceDomain
            ? _value.sourceDomain
            : sourceDomain // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$SourceItemImpl implements _SourceItem {
  const _$SourceItemImpl({
    required this.id,
    required this.topic,
    required this.category,
    required this.sourceDomain,
    required this.title,
    required this.body,
    required this.publishedAt,
    required final List<Citation> citations,
  }) : _citations = citations;

  factory _$SourceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceItemImplFromJson(json);

  @override
  final String id;
  @override
  final String topic;
  @override
  final String category;
  @override
  final String sourceDomain;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime publishedAt;
  final List<Citation> _citations;
  @override
  List<Citation> get citations {
    if (_citations is EqualUnmodifiableListView) return _citations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_citations);
  }

  @override
  String toString() {
    return 'SourceItem(id: $id, topic: $topic, category: $category, sourceDomain: $sourceDomain, title: $title, body: $body, publishedAt: $publishedAt, citations: $citations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sourceDomain, sourceDomain) ||
                other.sourceDomain == sourceDomain) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
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
    category,
    sourceDomain,
    title,
    body,
    publishedAt,
    const DeepCollectionEquality().hash(_citations),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceItemImplCopyWith<_$SourceItemImpl> get copyWith =>
      __$$SourceItemImplCopyWithImpl<_$SourceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceItemImplToJson(this);
  }
}

abstract class _SourceItem implements SourceItem {
  const factory _SourceItem({
    required final String id,
    required final String topic,
    required final String category,
    required final String sourceDomain,
    required final String title,
    required final String body,
    required final DateTime publishedAt,
    required final List<Citation> citations,
  }) = _$SourceItemImpl;

  factory _SourceItem.fromJson(Map<String, dynamic> json) =
      _$SourceItemImpl.fromJson;

  @override
  String get id;
  @override
  String get topic;
  @override
  String get category;
  @override
  String get sourceDomain;
  @override
  String get title;
  @override
  String get body;
  @override
  DateTime get publishedAt;
  @override
  List<Citation> get citations;
  @override
  @JsonKey(ignore: true)
  _$$SourceItemImplCopyWith<_$SourceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
