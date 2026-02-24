// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RuleProfileImpl _$$RuleProfileImplFromJson(Map<String, dynamic> json) =>
    _$RuleProfileImpl(
      id: json['id'] as String,
      version: (json['version'] as num).toInt(),
      topicPriorities: Map<String, int>.from(json['topicPriorities'] as Map),
      hardFilters: (json['hardFilters'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sourceAllowlist: (json['sourceAllowlist'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sourceBlocklist: (json['sourceBlocklist'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tone: $enumDecode(_$SummaryToneEnumMap, json['tone']),
      frequency: $enumDecode(_$DigestFrequencyEnumMap, json['frequency']),
      length: $enumDecode(_$DigestLengthEnumMap, json['length']),
      rankingTweaks: Map<String, int>.from(json['rankingTweaks'] as Map),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RuleProfileImplToJson(_$RuleProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'topicPriorities': instance.topicPriorities,
      'hardFilters': instance.hardFilters,
      'sourceAllowlist': instance.sourceAllowlist,
      'sourceBlocklist': instance.sourceBlocklist,
      'tone': _$SummaryToneEnumMap[instance.tone]!,
      'frequency': _$DigestFrequencyEnumMap[instance.frequency]!,
      'length': _$DigestLengthEnumMap[instance.length]!,
      'rankingTweaks': instance.rankingTweaks,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SummaryToneEnumMap = {
  SummaryTone.neutral: 'neutral',
  SummaryTone.analytical: 'analytical',
  SummaryTone.optimistic: 'optimistic',
  SummaryTone.critical: 'critical',
  SummaryTone.executive: 'executive',
};

const _$DigestFrequencyEnumMap = {
  DigestFrequency.daily: 'daily',
  DigestFrequency.weekdays: 'weekdays',
  DigestFrequency.threePerWeek: 'threePerWeek',
};

const _$DigestLengthEnumMap = {
  DigestLength.quick: 'quick',
  DigestLength.standard: 'standard',
  DigestLength.deep: 'deep',
};
