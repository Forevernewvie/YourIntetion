// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RuleProfile _$RuleProfileFromJson(Map<String, dynamic> json) {
  return _RuleProfile.fromJson(json);
}

/// @nodoc
mixin _$RuleProfile {
  String get id => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  Map<String, int> get topicPriorities => throw _privateConstructorUsedError;
  List<String> get hardFilters => throw _privateConstructorUsedError;
  List<String> get sourceAllowlist => throw _privateConstructorUsedError;
  List<String> get sourceBlocklist => throw _privateConstructorUsedError;
  SummaryTone get tone => throw _privateConstructorUsedError;
  DigestFrequency get frequency => throw _privateConstructorUsedError;
  DigestLength get length => throw _privateConstructorUsedError;
  Map<String, int> get rankingTweaks => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RuleProfileCopyWith<RuleProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RuleProfileCopyWith<$Res> {
  factory $RuleProfileCopyWith(
    RuleProfile value,
    $Res Function(RuleProfile) then,
  ) = _$RuleProfileCopyWithImpl<$Res, RuleProfile>;
  @useResult
  $Res call({
    String id,
    int version,
    Map<String, int> topicPriorities,
    List<String> hardFilters,
    List<String> sourceAllowlist,
    List<String> sourceBlocklist,
    SummaryTone tone,
    DigestFrequency frequency,
    DigestLength length,
    Map<String, int> rankingTweaks,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RuleProfileCopyWithImpl<$Res, $Val extends RuleProfile>
    implements $RuleProfileCopyWith<$Res> {
  _$RuleProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? topicPriorities = null,
    Object? hardFilters = null,
    Object? sourceAllowlist = null,
    Object? sourceBlocklist = null,
    Object? tone = null,
    Object? frequency = null,
    Object? length = null,
    Object? rankingTweaks = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            topicPriorities: null == topicPriorities
                ? _value.topicPriorities
                : topicPriorities // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            hardFilters: null == hardFilters
                ? _value.hardFilters
                : hardFilters // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sourceAllowlist: null == sourceAllowlist
                ? _value.sourceAllowlist
                : sourceAllowlist // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sourceBlocklist: null == sourceBlocklist
                ? _value.sourceBlocklist
                : sourceBlocklist // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tone: null == tone
                ? _value.tone
                : tone // ignore: cast_nullable_to_non_nullable
                      as SummaryTone,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as DigestFrequency,
            length: null == length
                ? _value.length
                : length // ignore: cast_nullable_to_non_nullable
                      as DigestLength,
            rankingTweaks: null == rankingTweaks
                ? _value.rankingTweaks
                : rankingTweaks // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RuleProfileImplCopyWith<$Res>
    implements $RuleProfileCopyWith<$Res> {
  factory _$$RuleProfileImplCopyWith(
    _$RuleProfileImpl value,
    $Res Function(_$RuleProfileImpl) then,
  ) = __$$RuleProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int version,
    Map<String, int> topicPriorities,
    List<String> hardFilters,
    List<String> sourceAllowlist,
    List<String> sourceBlocklist,
    SummaryTone tone,
    DigestFrequency frequency,
    DigestLength length,
    Map<String, int> rankingTweaks,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RuleProfileImplCopyWithImpl<$Res>
    extends _$RuleProfileCopyWithImpl<$Res, _$RuleProfileImpl>
    implements _$$RuleProfileImplCopyWith<$Res> {
  __$$RuleProfileImplCopyWithImpl(
    _$RuleProfileImpl _value,
    $Res Function(_$RuleProfileImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? topicPriorities = null,
    Object? hardFilters = null,
    Object? sourceAllowlist = null,
    Object? sourceBlocklist = null,
    Object? tone = null,
    Object? frequency = null,
    Object? length = null,
    Object? rankingTweaks = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RuleProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        topicPriorities: null == topicPriorities
            ? _value._topicPriorities
            : topicPriorities // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        hardFilters: null == hardFilters
            ? _value._hardFilters
            : hardFilters // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sourceAllowlist: null == sourceAllowlist
            ? _value._sourceAllowlist
            : sourceAllowlist // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sourceBlocklist: null == sourceBlocklist
            ? _value._sourceBlocklist
            : sourceBlocklist // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tone: null == tone
            ? _value.tone
            : tone // ignore: cast_nullable_to_non_nullable
                  as SummaryTone,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as DigestFrequency,
        length: null == length
            ? _value.length
            : length // ignore: cast_nullable_to_non_nullable
                  as DigestLength,
        rankingTweaks: null == rankingTweaks
            ? _value._rankingTweaks
            : rankingTweaks // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RuleProfileImpl implements _RuleProfile {
  const _$RuleProfileImpl({
    required this.id,
    required this.version,
    required final Map<String, int> topicPriorities,
    required final List<String> hardFilters,
    required final List<String> sourceAllowlist,
    required final List<String> sourceBlocklist,
    required this.tone,
    required this.frequency,
    required this.length,
    required final Map<String, int> rankingTweaks,
    required this.updatedAt,
  }) : _topicPriorities = topicPriorities,
       _hardFilters = hardFilters,
       _sourceAllowlist = sourceAllowlist,
       _sourceBlocklist = sourceBlocklist,
       _rankingTweaks = rankingTweaks;

  factory _$RuleProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$RuleProfileImplFromJson(json);

  @override
  final String id;
  @override
  final int version;
  final Map<String, int> _topicPriorities;
  @override
  Map<String, int> get topicPriorities {
    if (_topicPriorities is EqualUnmodifiableMapView) return _topicPriorities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topicPriorities);
  }

  final List<String> _hardFilters;
  @override
  List<String> get hardFilters {
    if (_hardFilters is EqualUnmodifiableListView) return _hardFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hardFilters);
  }

  final List<String> _sourceAllowlist;
  @override
  List<String> get sourceAllowlist {
    if (_sourceAllowlist is EqualUnmodifiableListView) return _sourceAllowlist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sourceAllowlist);
  }

  final List<String> _sourceBlocklist;
  @override
  List<String> get sourceBlocklist {
    if (_sourceBlocklist is EqualUnmodifiableListView) return _sourceBlocklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sourceBlocklist);
  }

  @override
  final SummaryTone tone;
  @override
  final DigestFrequency frequency;
  @override
  final DigestLength length;
  final Map<String, int> _rankingTweaks;
  @override
  Map<String, int> get rankingTweaks {
    if (_rankingTweaks is EqualUnmodifiableMapView) return _rankingTweaks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rankingTweaks);
  }

  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RuleProfile(id: $id, version: $version, topicPriorities: $topicPriorities, hardFilters: $hardFilters, sourceAllowlist: $sourceAllowlist, sourceBlocklist: $sourceBlocklist, tone: $tone, frequency: $frequency, length: $length, rankingTweaks: $rankingTweaks, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RuleProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(
              other._topicPriorities,
              _topicPriorities,
            ) &&
            const DeepCollectionEquality().equals(
              other._hardFilters,
              _hardFilters,
            ) &&
            const DeepCollectionEquality().equals(
              other._sourceAllowlist,
              _sourceAllowlist,
            ) &&
            const DeepCollectionEquality().equals(
              other._sourceBlocklist,
              _sourceBlocklist,
            ) &&
            (identical(other.tone, tone) || other.tone == tone) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.length, length) || other.length == length) &&
            const DeepCollectionEquality().equals(
              other._rankingTweaks,
              _rankingTweaks,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    version,
    const DeepCollectionEquality().hash(_topicPriorities),
    const DeepCollectionEquality().hash(_hardFilters),
    const DeepCollectionEquality().hash(_sourceAllowlist),
    const DeepCollectionEquality().hash(_sourceBlocklist),
    tone,
    frequency,
    length,
    const DeepCollectionEquality().hash(_rankingTweaks),
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RuleProfileImplCopyWith<_$RuleProfileImpl> get copyWith =>
      __$$RuleProfileImplCopyWithImpl<_$RuleProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RuleProfileImplToJson(this);
  }
}

abstract class _RuleProfile implements RuleProfile {
  const factory _RuleProfile({
    required final String id,
    required final int version,
    required final Map<String, int> topicPriorities,
    required final List<String> hardFilters,
    required final List<String> sourceAllowlist,
    required final List<String> sourceBlocklist,
    required final SummaryTone tone,
    required final DigestFrequency frequency,
    required final DigestLength length,
    required final Map<String, int> rankingTweaks,
    required final DateTime updatedAt,
  }) = _$RuleProfileImpl;

  factory _RuleProfile.fromJson(Map<String, dynamic> json) =
      _$RuleProfileImpl.fromJson;

  @override
  String get id;
  @override
  int get version;
  @override
  Map<String, int> get topicPriorities;
  @override
  List<String> get hardFilters;
  @override
  List<String> get sourceAllowlist;
  @override
  List<String> get sourceBlocklist;
  @override
  SummaryTone get tone;
  @override
  DigestFrequency get frequency;
  @override
  DigestLength get length;
  @override
  Map<String, int> get rankingTweaks;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RuleProfileImplCopyWith<_$RuleProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
