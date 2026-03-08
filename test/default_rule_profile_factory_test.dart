import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/rule_profile.dart';
import 'package:vibecodingexpert/features/digest/domain/factories/default_rule_profile_factory.dart';

void main() {
  group('DefaultRuleProfileFactory', () {
    test('creates deterministic default profile values', () {
      final updatedAt = DateTime.utc(2026, 3, 8, 0, 0);

      final profile = DefaultRuleProfileFactory.create(updatedAt: updatedAt);

      expect(profile.id, '');
      expect(profile.version, 1);
      expect(profile.topicPriorities['AI'], 90);
      expect(profile.hardFilters, ['Celebrity Gossip']);
      expect(profile.tone, SummaryTone.neutral);
      expect(profile.frequency, DigestFrequency.weekdays);
      expect(profile.length, DigestLength.quick);
      expect(profile.updatedAt, updatedAt);
    });
  });
}
