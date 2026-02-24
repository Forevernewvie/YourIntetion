import 'dart:io';

/// Purpose: Benchmark legacy hard-filter scanning vs automaton-based multi-pattern matching.
void main() {
  const scenarios = <_BenchmarkScenario>[
    _BenchmarkScenario(candidateCount: 1000, filterCount: 1000),
    _BenchmarkScenario(candidateCount: 5000, filterCount: 5000),
    _BenchmarkScenario(candidateCount: 7000, filterCount: 7000),
  ];

  for (final scenario in scenarios) {
    final filters = List<String>.generate(
      scenario.filterCount,
      (index) => '|token_$index|',
      growable: false,
    );
    final haystacks = List<String>.generate(scenario.candidateCount, (index) {
      final tokenIndex = scenario.filterCount - 1 - (index % 31);
      return 'topic_${index % 7} title_${index % 9} body |token_$tokenIndex|';
    }, growable: false);

    final legacyMicros = _measureMicros(
      () => _legacyFilter(haystacks, filters),
    );
    final optimizedMicros = _measureMicros(
      () => _optimizedFilter(haystacks, filters),
    );
    final speedup = legacyMicros / optimizedMicros;

    stdout.writeln(
      'candidates=${scenario.candidateCount}'
      ' filters=${scenario.filterCount}'
      ' legacy=${legacyMicros}us'
      ' optimized=${optimizedMicros}us'
      ' speedup=${speedup.toStringAsFixed(2)}x',
    );
  }
}

/// Purpose: Measure median runtime in microseconds after warmup.
int _measureMicros(int Function() run) {
  const iterations = 14;
  const warmup = 4;
  final samples = <int>[];

  for (var i = 0; i < iterations; i++) {
    final watch = Stopwatch()..start();
    run();
    watch.stop();
    if (i >= warmup) {
      samples.add(watch.elapsedMicroseconds);
    }
  }

  samples.sort();
  return samples[samples.length ~/ 2];
}

/// Purpose: Reproduce legacy nested scanning behavior.
int _legacyFilter(List<String> haystacks, List<String> filters) {
  var blocked = 0;
  for (final haystack in haystacks) {
    final hasMatch = filters.any(haystack.contains);
    if (hasMatch) {
      blocked++;
    }
  }
  return blocked;
}

/// Purpose: Apply automaton matcher behavior equivalent to legacy substring checks.
int _optimizedFilter(List<String> haystacks, List<String> filters) {
  final matcher = _AhoMatcher.fromPatterns(filters);
  var blocked = 0;
  for (final haystack in haystacks) {
    if (matcher.matches(haystack)) {
      blocked++;
    }
  }
  return blocked;
}

/// Purpose: Aho-Corasick matcher for multi-substring checks in linear scan time.
final class _AhoMatcher {
  _AhoMatcher._(this._nodes);

  final List<_Node> _nodes;

  /// Purpose: Build automaton trie and failure links from filter patterns.
  factory _AhoMatcher.fromPatterns(List<String> patterns) {
    final nodes = <_Node>[_Node.empty()];

    for (final pattern in patterns) {
      if (pattern.isEmpty) {
        continue;
      }
      var state = 0;
      for (final codeUnit in pattern.codeUnits) {
        final next = nodes[state].next;
        final existing = next[codeUnit];
        if (existing != null) {
          state = existing;
          continue;
        }

        final nextState = nodes.length;
        next[codeUnit] = nextState;
        nodes.add(_Node.empty());
        state = nextState;
      }
      nodes[state].out = true;
    }

    final queue = <int>[];
    for (final entry in nodes[0].next.entries) {
      final child = entry.value;
      nodes[child].fail = 0;
      queue.add(child);
    }

    var cursor = 0;
    while (cursor < queue.length) {
      final state = queue[cursor++];
      final transitions = nodes[state].next.entries.toList(growable: false);
      for (final transition in transitions) {
        final codeUnit = transition.key;
        final nextState = transition.value;
        var failure = nodes[state].fail;

        while (failure != 0 && !nodes[failure].next.containsKey(codeUnit)) {
          failure = nodes[failure].fail;
        }

        final fallback = nodes[failure].next[codeUnit];
        if (fallback != null) {
          failure = fallback;
        }

        nodes[nextState].fail = failure;
        nodes[nextState].out = nodes[nextState].out || nodes[failure].out;
        queue.add(nextState);
      }
    }

    return _AhoMatcher._(nodes);
  }

  /// Purpose: Check if text contains any registered pattern.
  bool matches(String text) {
    var state = 0;
    for (final codeUnit in text.codeUnits) {
      while (state != 0 && !_nodes[state].next.containsKey(codeUnit)) {
        state = _nodes[state].fail;
      }
      final nextState = _nodes[state].next[codeUnit];
      if (nextState != null) {
        state = nextState;
      }
      if (_nodes[state].out) {
        return true;
      }
    }
    return false;
  }
}

/// Purpose: Hold automaton node transitions/failure metadata.
final class _Node {
  _Node({required this.next, required this.fail, required this.out});

  final Map<int, int> next;
  int fail;
  bool out;

  /// Purpose: Construct empty node with default metadata.
  factory _Node.empty() => _Node(next: <int, int>{}, fail: 0, out: false);
}

/// Purpose: Hold benchmark scenario parameters.
final class _BenchmarkScenario {
  const _BenchmarkScenario({
    required this.candidateCount,
    required this.filterCount,
  });

  final int candidateCount;
  final int filterCount;
}
