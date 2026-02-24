// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedbackEvent _$FeedbackEventFromJson(Map<String, dynamic> json) {
  return _FeedbackEvent.fromJson(json);
}

/// @nodoc
mixin _$FeedbackEvent {
  String get id => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackEventCopyWith<FeedbackEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackEventCopyWith<$Res> {
  factory $FeedbackEventCopyWith(
    FeedbackEvent value,
    $Res Function(FeedbackEvent) then,
  ) = _$FeedbackEventCopyWithImpl<$Res, FeedbackEvent>;
  @useResult
  $Res call({
    String id,
    String itemId,
    int rating,
    String reason,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FeedbackEventCopyWithImpl<$Res, $Val extends FeedbackEvent>
    implements $FeedbackEventCopyWith<$Res> {
  _$FeedbackEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? rating = null,
    Object? reason = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedbackEventImplCopyWith<$Res>
    implements $FeedbackEventCopyWith<$Res> {
  factory _$$FeedbackEventImplCopyWith(
    _$FeedbackEventImpl value,
    $Res Function(_$FeedbackEventImpl) then,
  ) = __$$FeedbackEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String itemId,
    int rating,
    String reason,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FeedbackEventImplCopyWithImpl<$Res>
    extends _$FeedbackEventCopyWithImpl<$Res, _$FeedbackEventImpl>
    implements _$$FeedbackEventImplCopyWith<$Res> {
  __$$FeedbackEventImplCopyWithImpl(
    _$FeedbackEventImpl _value,
    $Res Function(_$FeedbackEventImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? rating = null,
    Object? reason = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$FeedbackEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackEventImpl implements _FeedbackEvent {
  const _$FeedbackEventImpl({
    required this.id,
    required this.itemId,
    required this.rating,
    required this.reason,
    required this.createdAt,
  });

  factory _$FeedbackEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackEventImplFromJson(json);

  @override
  final String id;
  @override
  final String itemId;
  @override
  final int rating;
  @override
  final String reason;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FeedbackEvent(id: $id, itemId: $itemId, rating: $rating, reason: $reason, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, itemId, rating, reason, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackEventImplCopyWith<_$FeedbackEventImpl> get copyWith =>
      __$$FeedbackEventImplCopyWithImpl<_$FeedbackEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackEventImplToJson(this);
  }
}

abstract class _FeedbackEvent implements FeedbackEvent {
  const factory _FeedbackEvent({
    required final String id,
    required final String itemId,
    required final int rating,
    required final String reason,
    required final DateTime createdAt,
  }) = _$FeedbackEventImpl;

  factory _FeedbackEvent.fromJson(Map<String, dynamic> json) =
      _$FeedbackEventImpl.fromJson;

  @override
  String get id;
  @override
  String get itemId;
  @override
  int get rating;
  @override
  String get reason;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackEventImplCopyWith<_$FeedbackEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
