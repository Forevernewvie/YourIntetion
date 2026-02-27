/// <reference path="../pb_data/types.d.ts" />

const pscApiHandler = (e) => {
  // Purpose: Hold unit conversion constants used in pipeline and pagination math.
  const timeUnits = Object.freeze({
    millisecondsPerMinute: 60 * 1000,
    minutesPerDay: 24 * 60,
    minutesPerHour: 60,
    secondsPerHour: 60,
  })

  // Purpose: Hold immutable score composition weights for quality calculation.
  const qualityWeights = Object.freeze({
    diversity: 0.4,
    freshness: 0.4,
    baseline: 0.2,
  })

  // Purpose: Keep route behavior deterministic by centralizing length policy caps.
  const lengthCapByPolicy = Object.freeze({
    quick: 5,
    standard: 10,
    deep: 15,
  })

  const nowIso = () => new Date().toISOString()

  const makeTraceId = () => {
    const path = e.request ? String(e.request.url.path || "") : ""
    return $security.sha256(`${Date.now()}|${Math.random()}|${path}`).slice(0, runtimeConfig.traceIdLength)
  }

  const sendError = (status, code, message, details) => {
    $app.logger().error(
      "psc_response_error",
      "context",
      JSON.stringify({
        traceId,
        status,
        code,
        path: e.request ? String(e.request.url.path || "") : "",
      }),
    )
    e.json(status, {
      code,
      message,
      details: details || {},
      traceId,
    })
  }

  const fail = (status, code, message, details) => {
    const error = new Error(message)
    error.__psc = true
    error.status = status
    error.code = code
    error.details = details || {}
    throw error
  }

  const respondJson = (status, data) => {
    $app.logger().info(
      "psc_response_ok",
      "context",
      JSON.stringify({
        traceId,
        status,
        path: e.request ? String(e.request.url.path || "") : "",
      }),
    )
    e.json(status, data)
  }

  const asPlain = (value, fallback) => {
    if (value === null || value === undefined) {
      return fallback
    }

    try {
      return JSON.parse(JSON.stringify(value))
    } catch (_) {
      return fallback
    }
  }

  const asArray = (value) => {
    if (Array.isArray(value)) {
      return value
    }
    if (value === null || value === undefined) {
      return []
    }

    return [value]
  }

  const clamp = (value, minValue, maxValue) => {
    if (value < minValue) {
      return minValue
    }
    if (value > maxValue) {
      return maxValue
    }

    return value
  }

  const round = (value, digits) => {
    const p = Math.pow(10, digits)
    return Math.round(value * p) / p
  }

  const parseMs = (value) => {
    const parsed = Date.parse(value)
    if (Number.isNaN(parsed)) {
      return 0
    }
    return parsed
  }

  const boolFromEnv = (name, defaultValue) => {
    const raw = ($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return defaultValue
    }

    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }

  const readEnv = (name, defaultValue) => {
    const raw = $os.getenv(name)
    if (!raw || !raw.trim()) {
      return defaultValue
    }

    return raw.trim()
  }

  // Purpose: Parse positive integer environment variables with strict fallback.
  const parsePositiveIntEnv = (name, fallbackValue) => {
    const raw = readEnv(name, "")
    if (!raw) {
      return fallbackValue
    }

    const parsed = Number(raw)
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }

    return Math.floor(parsed)
  }

  // Purpose: Configure runtime tunables from environment without code-level hardcoding.
  const runtimeConfig = {
    traceIdLength: parsePositiveIntEnv("PSC_TRACE_ID_LENGTH", 24),
    sourceLookbackHours: parsePositiveIntEnv("PSC_SOURCE_LOOKBACK_HOURS", 48),
    sourceCandidateLimit: parsePositiveIntEnv("PSC_SOURCE_CANDIDATE_LIMIT", 500),
    digestItemsReadLimit: parsePositiveIntEnv("PSC_DIGEST_ITEMS_READ_LIMIT", 100),
    digestCitationsReadLimit: parsePositiveIntEnv("PSC_DIGEST_CITATIONS_READ_LIMIT", 20),
    savedDigestsDefaultLimit: parsePositiveIntEnv("PSC_SAVED_DIGESTS_DEFAULT_LIMIT", 20),
    savedDigestsMaxLimit: parsePositiveIntEnv("PSC_SAVED_DIGESTS_MAX_LIMIT", 50),
    freshnessMaxMinutes: parsePositiveIntEnv("PSC_FRESHNESS_MAX_MINUTES", timeUnits.minutesPerDay),
  }

  const traceId = makeTraceId()

  const normalizeStringArray = (value) => {
    const seen = new Set()
    const normalized = []

    asArray(value).forEach((entry) => {
      const v = String(entry || "").trim().toLowerCase()
      if (!v) {
        return
      }
      if (!seen.has(v)) {
        seen.add(v)
        normalized.push(v)
      }
    })

    return normalized
  }

  const decodeJsonField = (value, fallback) => {
    if (value === null || value === undefined || value === "") {
      return fallback
    }

    if (typeof value === "string") {
      try {
        return JSON.parse(value)
      } catch (_) {
        return fallback
      }
    }

    if (Array.isArray(value) && value.length > 0 && typeof value[0] === "number") {
      try {
        let raw = ""
        value.forEach((code) => {
          raw += String.fromCharCode(code)
        })
        return JSON.parse(raw)
      } catch (_) {
        return fallback
      }
    }

    return asPlain(value, fallback)
  }

  const normalizeTopicPriorities = (value) => {
    const data = asPlain(value, {})
    const result = {}

    Object.keys(data).forEach((key) => {
      const topic = String(key || "").trim()
      if (!topic) {
        return
      }

      const parsed = Number(data[key])
      if (Number.isNaN(parsed)) {
        return
      }

      result[topic] = round(clamp(parsed, 0, 1), 4)
    })

    return result
  }

  const normalizeRankingTweaks = (value) => {
    const data = asPlain(value, {})
    const trustBoost = Number(data.trustBoost)
    const freshnessBoost = Number(data.freshnessBoost)
    const priorityBoost = Number(data.priorityBoost)

    return {
      trustBoost: round(clamp(Number.isNaN(trustBoost) ? 0.25 : trustBoost, 0, 2), 4),
      freshnessBoost: round(clamp(Number.isNaN(freshnessBoost) ? 0.2 : freshnessBoost, 0, 2), 4),
      priorityBoost: round(clamp(Number.isNaN(priorityBoost) ? 0.55 : priorityBoost, 0, 2), 4),
    }
  }

  // Purpose: Normalize list-like value into a lowercase set for O(1) membership checks.
  const toNormalizedSet = (value) => new Set(normalizeStringArray(value))

  const defaults = {
    topic_priorities: {
      AI: 0.9,
      markets: 0.7,
      productivity: 0.6,
    },
    hard_filters: [],
    source_allowlist: [],
    source_blocklist: [],
    tone: "neutral",
    frequency: "daily",
    length: "standard",
    ranking_tweaks: {
      trustBoost: 0.25,
      freshnessBoost: 0.2,
      priorityBoost: 0.55,
    },
  }

  const normalizeRulePayload = (payload, baseDefaults) => {
    const input = asPlain(payload, {})

    const normalized = {
      topic_priorities: normalizeTopicPriorities(
        input.topic_priorities !== undefined ? input.topic_priorities : baseDefaults.topic_priorities,
      ),
      hard_filters: normalizeStringArray(
        input.hard_filters !== undefined ? input.hard_filters : baseDefaults.hard_filters,
      ),
      source_allowlist: normalizeStringArray(
        input.source_allowlist !== undefined ? input.source_allowlist : baseDefaults.source_allowlist,
      ),
      source_blocklist: normalizeStringArray(
        input.source_blocklist !== undefined ? input.source_blocklist : baseDefaults.source_blocklist,
      ),
      tone: String(input.tone !== undefined ? input.tone : baseDefaults.tone).trim(),
      frequency: String(input.frequency !== undefined ? input.frequency : baseDefaults.frequency).trim(),
      length: String(input.length !== undefined ? input.length : baseDefaults.length).trim(),
      ranking_tweaks: normalizeRankingTweaks(
        input.ranking_tweaks !== undefined ? input.ranking_tweaks : baseDefaults.ranking_tweaks,
      ),
    }

    const blockSet = new Set(normalized.source_blocklist)
    normalized.source_allowlist = normalized.source_allowlist.filter((entry) => !blockSet.has(entry))

    return normalized
  }

  const validateRulePayload = (rule) => {
    const validTones = ["neutral", "analytical", "optimistic", "critical", "executive"]
    const validFrequencies = ["daily", "weekdays", "threePerWeek"]
    const validLengths = ["quick", "standard", "deep"]

    if (!validTones.includes(rule.tone)) {
      fail(422, "VALIDATION_FAILED", "tone must be one of neutral|analytical|optimistic|critical|executive")
    }

    if (!validFrequencies.includes(rule.frequency)) {
      fail(422, "VALIDATION_FAILED", "frequency must be one of daily|weekdays|threePerWeek")
    }

    if (!validLengths.includes(rule.length)) {
      fail(422, "VALIDATION_FAILED", "length must be one of quick|standard|deep")
    }
  }

  const getAuth = () => {
    if (e.auth) {
      return e.auth
    }

    const requestInfo = e.requestInfo()
    if (requestInfo && requestInfo.auth) {
      return requestInfo.auth
    }

    return null
  }

  const resolveContext = () => {
    const allowGuestMode = boolFromEnv("ALLOW_GUEST_MODE", true)
    const authRecord = getAuth()

    if (authRecord) {
      let authCollectionName = ""
      try {
        authCollectionName = String(authRecord.collection().name || "")
      } catch (_) {
        authCollectionName = ""
      }

      if (authCollectionName && authCollectionName !== "users") {
        fail(403, "FORBIDDEN", "Only users authentication tokens are allowed")
      }

      return {
        mode: "auth",
        userId: authRecord.id,
      }
    }

    if (allowGuestMode) {
      return {
        mode: "guest",
        userId: "",
      }
    }

    fail(401, "UNAUTHORIZED", "Authentication required")
  }

  const assertProfileAccess = (profileRecord, context) => {
    const owner = profileRecord.getString("user")
    if (context.mode === "guest") {
      if (owner) {
        fail(403, "FORBIDDEN", "Guest mode can only access guest profile")
      }
      return
    }

    if (owner !== context.userId) {
      fail(403, "FORBIDDEN", "Profile does not belong to requester")
    }
  }

  const assertDigestAccess = (digestRecord, context) => {
    const owner = digestRecord.getString("user")
    if (context.mode === "guest") {
      if (owner) {
        fail(403, "FORBIDDEN", "Guest mode can only access guest digest")
      }
      return
    }

    if (owner !== context.userId) {
      fail(403, "FORBIDDEN", "Digest does not belong to requester")
    }
  }

  const findProfileById = (profileId) => {
    try {
      return $app.findRecordById("rule_profiles", profileId)
    } catch (_) {
      fail(404, "NOT_FOUND", "Rule profile not found", { profileId })
    }
  }

  const findLatestProfile = (context) => {
    const filter = context.mode === "guest" ? "user = ''" : "user = {:userId}"
    const params = context.mode === "guest" ? [] : [{ userId: context.userId }]

    const records = $app.findRecordsByFilter(
      "rule_profiles",
      filter,
      "-updated_at,-id",
      1,
      0,
      ...params,
    )

    if (!records || records.length === 0) {
      return null
    }

    return records[0]
  }

  const createProfileRecord = (context, normalizedRule, version, explicitId) => {
    const collection = $app.findCollectionByNameOrId("rule_profiles")
    const record = new Record(collection)

    if (explicitId) {
      record.set("id", explicitId)
    }

    record.set("user", context.userId)
    record.set("version", version)
    record.set("topic_priorities", normalizedRule.topic_priorities)
    record.set("hard_filters", normalizedRule.hard_filters)
    record.set("source_allowlist", normalizedRule.source_allowlist)
    record.set("source_blocklist", normalizedRule.source_blocklist)
    record.set("tone", normalizedRule.tone)
    record.set("frequency", normalizedRule.frequency)
    record.set("length", normalizedRule.length)
    record.set("ranking_tweaks", normalizedRule.ranking_tweaks)
    record.set("updated_at", nowIso())

    $app.save(record)
    return record
  }

  const ensureGuestProfile = (context) => {
    const latestGuest = findLatestProfile(context)
    if (latestGuest && !latestGuest.getString("user")) {
      return latestGuest
    }

    const normalizedRule = normalizeRulePayload(defaults, defaults)
    validateRulePayload(normalizedRule)
    return createProfileRecord(context, normalizedRule, 1, "")
  }

  const resolveProfile = (context) => {
    const queryProfileId = e.request ? String(e.request.url.query().get("ruleProfileId") || "").trim() : ""

    if (context.mode === "guest") {
      const scopedGuestProfile = ensureGuestProfile(context)
      if (queryProfileId && queryProfileId !== scopedGuestProfile.id) {
        fail(403, "FORBIDDEN", "Guest mode can access only scoped guest profile")
      }
      return scopedGuestProfile
    }

    if (queryProfileId) {
      const profile = findProfileById(queryProfileId)
      assertProfileAccess(profile, context)
      return profile
    }

    const latest = findLatestProfile(context)
    if (latest) {
      return latest
    }

    const normalizedRule = normalizeRulePayload(defaults, defaults)
    validateRulePayload(normalizedRule)
    return createProfileRecord(context, normalizedRule, 1, "")
  }

  const profileToRuleConfig = (profileRecord) => normalizeRulePayload({
    topic_priorities: decodeJsonField(profileRecord.get("topic_priorities"), {}),
    hard_filters: decodeJsonField(profileRecord.get("hard_filters"), []),
    source_allowlist: decodeJsonField(profileRecord.get("source_allowlist"), []),
    source_blocklist: decodeJsonField(profileRecord.get("source_blocklist"), []),
    tone: profileRecord.getString("tone"),
    frequency: profileRecord.getString("frequency"),
    length: profileRecord.getString("length"),
    ranking_tweaks: decodeJsonField(profileRecord.get("ranking_tweaks"), {}),
  }, defaults)

  const entryToCandidate = (record, nowMs) => {
    const publishedAt = record.getString("published_at")
    const publishedAtMs = parseMs(publishedAt)

    return {
      id: record.id,
      sourceName: record.getString("source_name"),
      sourceDomain: record.getString("source_domain"),
      topic: record.getString("topic"),
      title: record.getString("title"),
      snippet: record.getString("content_snippet"),
      canonicalUrl: record.getString("canonical_url"),
      publishedAt,
      publishedAtMs,
      trustScore: clamp(record.getFloat("trust_score"), 0, 100),
      freshnessMinutes: Math.max(0, Math.floor((nowMs - publishedAtMs) / timeUnits.millisecondsPerMinute)),
    }
  }

  const loadCandidates = (nowMs) => {
    const minPublishedAt = new Date(
      Date.now() - (runtimeConfig.sourceLookbackHours * timeUnits.minutesPerHour * timeUnits.secondsPerHour * 1000),
    ).toISOString()

    const records = $app.findRecordsByFilter(
      "source_entries",
      "published_at >= {:minPublishedAt} && blocked = false",
      "-published_at,-id",
      runtimeConfig.sourceCandidateLimit,
      0,
      { minPublishedAt },
    )

    return asArray(records).map((record) => entryToCandidate(record, nowMs))
  }

  const buildMultiPatternMatcher = (patterns) => {
    const normalized = asArray(patterns)
      .map((entry) => String(entry || "").trim().toLowerCase())
      .filter((entry) => entry.length > 0)

    if (normalized.length === 0) {
      return null
    }

    const nodes = [
      {
        next: {},
        fail: 0,
        out: false,
      },
    ]

    normalized.forEach((pattern) => {
      let state = 0
      for (const ch of pattern) {
        if (nodes[state].next[ch] === undefined) {
          nodes[state].next[ch] = nodes.length
          nodes.push({
            next: {},
            fail: 0,
            out: false,
          })
        }
        state = nodes[state].next[ch]
      }
      nodes[state].out = true
    })

    const queue = []
    Object.keys(nodes[0].next).forEach((ch) => {
      const child = nodes[0].next[ch]
      nodes[child].fail = 0
      queue.push(child)
    })

    // Purpose: Use cursor-based BFS queue traversal to avoid Array.shift O(N^2) behavior.
    let queueCursor = 0
    while (queueCursor < queue.length) {
      const state = queue[queueCursor]
      queueCursor += 1
      const transitions = nodes[state].next
      Object.keys(transitions).forEach((ch) => {
        const nextState = transitions[ch]
        let failure = nodes[state].fail

        while (failure !== 0 && nodes[failure].next[ch] === undefined) {
          failure = nodes[failure].fail
        }

        if (nodes[failure].next[ch] !== undefined) {
          failure = nodes[failure].next[ch]
        }

        nodes[nextState].fail = failure
        nodes[nextState].out = nodes[nextState].out || nodes[failure].out
        queue.push(nextState)
      })
    }

    return {
      matches: (text) => {
        let state = 0
        for (const ch of text) {
          while (state !== 0 && nodes[state].next[ch] === undefined) {
            state = nodes[state].fail
          }

          if (nodes[state].next[ch] !== undefined) {
            state = nodes[state].next[ch]
          }

          if (nodes[state].out) {
            return true
          }
        }
        return false
      },
    }
  }

  const applyHardFilters = (candidates, hardFilters) => {
    if (!hardFilters || hardFilters.length === 0) {
      return candidates
    }

    const matcher = buildMultiPatternMatcher(hardFilters)
    if (!matcher) {
      return candidates
    }

    return candidates.filter((candidate) => {
      const haystack = `${candidate.topic} ${candidate.title} ${candidate.snippet} ${candidate.sourceDomain}`.toLowerCase()
      return !matcher.matches(haystack)
    })
  }

  const applySourceFilters = (candidates, allowlist, blocklist) => {
    const allowSet = toNormalizedSet(allowlist)
    const blockSet = toNormalizedSet(blocklist)
    const useAllow = allowSet.size > 0

    return candidates.filter((candidate) => {
      const domain = candidate.sourceDomain.toLowerCase()
      const name = candidate.sourceName.toLowerCase()

      if (blockSet.has(domain) || blockSet.has(name)) {
        return false
      }

      if (!useAllow) {
        return true
      }

      return allowSet.has(domain) || allowSet.has(name)
    })
  }

  const toneSummary = (candidate, tone) => {
    const base = candidate.snippet && candidate.snippet.trim() ? candidate.snippet.trim() : candidate.title

    if (tone === "analytical") {
      return `Key signal: ${base}`
    }
    if (tone === "optimistic") {
      return `Opportunity: ${base}`
    }
    if (tone === "critical") {
      return `Risk watch: ${base}`
    }
    if (tone === "executive") {
      return `Executive brief: ${base}`
    }

    return base
  }

  const topicPriorityScore = (candidate, rules) => {
    const topicPriority = Number(
      rules.topic_priorities[candidate.topic] ||
      rules.topic_priorities[candidate.topic.toLowerCase()] ||
      0,
    )

    return {
      topicPriority: round(topicPriority, 4),
      baseScore: round(topicPriority, 6),
      trustNorm: round(clamp(candidate.trustScore / 100, 0, 1), 6),
      freshnessNorm: round(clamp(1 - (candidate.freshnessMinutes / runtimeConfig.freshnessMaxMinutes), 0, 1), 6),
    }
  }

  const deterministicSortBy = (items, scoreKey) => items.sort((left, right) => {
    const leftScore = Number(left[scoreKey] || 0)
    const rightScore = Number(right[scoreKey] || 0)

    if (rightScore !== leftScore) {
      return rightScore - leftScore
    }

    if (right.publishedAtMs !== left.publishedAtMs) {
      return right.publishedAtMs - left.publishedAtMs
    }

    const sourceDiff = left.sourceName.localeCompare(right.sourceName)
    if (sourceDiff !== 0) {
      return sourceDiff
    }

    return left.id.localeCompare(right.id)
  })

  const computeQuality = (items) => {
    if (!items || items.length === 0) {
      return 0
    }

    const uniqueDomains = new Set(items.map((item) => item.sourceDomain)).size
    const diversity = uniqueDomains / items.length
    const avgFreshness = items.reduce((acc, item) => acc + item.freshnessMinutes, 0) / items.length
    const freshness = clamp(1 - (avgFreshness / runtimeConfig.freshnessMaxMinutes), 0, 1)

    return round(
      clamp(
        (qualityWeights.diversity * diversity) +
        (qualityWeights.freshness * freshness) +
        qualityWeights.baseline,
        0,
        1,
      ),
      4,
    )
  }

  const buildPipeline = (profileRecord) => {
    const stageStart = Date.now()
    const rules = profileToRuleConfig(profileRecord)
    validateRulePayload(rules)

    const nowIsoValue = nowIso()
    const nowMs = parseMs(nowIsoValue)

    let t0 = Date.now()
    const loadedCandidates = loadCandidates(nowMs)
    const loadMs = Date.now() - t0

    t0 = Date.now()
    const hardFiltered = applyHardFilters(loadedCandidates, rules.hard_filters)
    const hardMs = Date.now() - t0

    t0 = Date.now()
    const sourceFiltered = applySourceFilters(hardFiltered, rules.source_allowlist, rules.source_blocklist)
    const sourceMs = Date.now() - t0

    t0 = Date.now()
    const topicScored = sourceFiltered.map((candidate) => {
      const scoredResult = topicPriorityScore(candidate, rules)
      return {
        id: candidate.id,
        sourceName: candidate.sourceName,
        sourceDomain: candidate.sourceDomain,
        topic: candidate.topic,
        topicPriority: scoredResult.topicPriority,
        baseScore: scoredResult.baseScore,
        trustNorm: scoredResult.trustNorm,
        freshnessNorm: scoredResult.freshnessNorm,
        freshnessMinutes: candidate.freshnessMinutes,
        publishedAt: candidate.publishedAt,
        publishedAtMs: candidate.publishedAtMs,
        canonicalUrl: candidate.canonicalUrl,
        summary: toneSummary(candidate, rules.tone),
      }
    })
    const topicAndToneMs = Date.now() - t0

    t0 = Date.now()
    const preRankSorted = deterministicSortBy(topicScored, "baseScore")
    const selectedByLength = preRankSorted.slice(0, lengthCapByPolicy[rules.length] || lengthCapByPolicy.standard)
    const lengthCapMs = Date.now() - t0

    t0 = Date.now()
    const rankingTweaked = selectedByLength.map((candidate) => {
      const rankingScore = round(
        (candidate.topicPriority * rules.ranking_tweaks.priorityBoost) +
        (candidate.trustNorm * rules.ranking_tweaks.trustBoost) +
        (candidate.freshnessNorm * rules.ranking_tweaks.freshnessBoost),
        6,
      )

      return {
        ...candidate,
        finalScore: rankingScore,
        whyReason: [
          "hard filter pass",
          rules.source_allowlist.length > 0 ? "allowlist matched" : "default source policy",
          `topic priority ${candidate.topic}=${candidate.topicPriority}`,
          `tone=${rules.tone}`,
          `length=${rules.length}`,
          `ranking=${rankingScore}`,
        ].join("; "),
      }
    })
    const rankingTweaksMs = Date.now() - t0

    t0 = Date.now()
    const finalSorted = deterministicSortBy(rankingTweaked, "finalScore")
    const finalSortMs = Date.now() - t0

    $app.logger().info(
      "psc_pipeline_timing",
      "context",
      JSON.stringify({
        traceId,
        loadMs,
        hardMs,
        sourceMs,
        topicAndToneMs,
        lengthCapMs,
        rankingTweaksMs,
        finalSortMs,
        totalMs: Date.now() - stageStart,
      }),
    )

    return {
      nowIsoValue,
      items: finalSorted,
      qualityScore: computeQuality(finalSorted),
      sourceSnapshotHash: $security.sha256(
        preRankSorted.map((item) => `${item.id}:${item.publishedAt}`).join("|"),
      ),
    }
  }

  const utcHourBucket = (isoValue) => {
    const date = new Date(isoValue)
    date.setUTCMinutes(0, 0, 0)
    return date.toISOString().slice(0, 13)
  }

  const buildDigestKey = (context, profileId, nowIsoValue, snapshotHash) => {
    const userScope = context.mode === "guest" ? "guest" : context.userId
    return $security.sha256(`${userScope}|${profileId}|${utcHourBucket(nowIsoValue)}|${snapshotHash}`)
  }

  const findDigestByKey = (digestKey) => {
    try {
      return $app.findFirstRecordByFilter("digests", "digest_key = {:digestKey}", { digestKey })
    } catch (_) {
      return null
    }
  }

  const serializeDigest = (digestRecord) => {
    const itemRecords = $app.findRecordsByFilter(
      "digest_items",
      "digest = {:digestId}",
      "+rank,+id",
      runtimeConfig.digestItemsReadLimit,
      0,
      { digestId: digestRecord.id },
    )

    const items = asArray(itemRecords).map((itemRecord) => {
      const citationRecords = $app.findRecordsByFilter(
        "citations",
        "digest_item = {:digestItemId}",
        "+published_at,+id",
        runtimeConfig.digestCitationsReadLimit,
        0,
        { digestItemId: itemRecord.id },
      )

      return {
        id: itemRecord.id,
        topic: itemRecord.getString("topic"),
        whyReason: itemRecord.getString("why_reason"),
        summary: itemRecord.getString("summary"),
        freshnessMinutes: itemRecord.getInt("freshness_minutes"),
        citations: asArray(citationRecords).map((citationRecord) => ({
          id: citationRecord.id,
          sourceName: citationRecord.getString("source_name"),
          canonicalUrl: citationRecord.getString("canonical_url"),
          publishedAt: citationRecord.getString("published_at"),
        })),
      }
    })

    return {
      id: digestRecord.id,
      profileId: digestRecord.getString("profile"),
      generatedAt: digestRecord.getString("generated_at"),
      qualityScore: round(digestRecord.getFloat("quality_score"), 4),
      items,
    }
  }

  const persistDigest = (profileRecord, pipeline, digestKey, context) => {
    let persistedDigest = null

    try {
      $app.runInTransaction((txApp) => {
        const digestCollection = txApp.findCollectionByNameOrId("digests")
        persistedDigest = new Record(digestCollection)
        persistedDigest.set("user", context.userId)
        persistedDigest.set("profile", profileRecord.id)
        persistedDigest.set("digest_key", digestKey)
        persistedDigest.set("generated_at", pipeline.nowIsoValue)
        persistedDigest.set("quality_score", pipeline.qualityScore)
        persistedDigest.set("saved", false)
        txApp.save(persistedDigest)

        const digestItemsCollection = txApp.findCollectionByNameOrId("digest_items")
        const citationsCollection = txApp.findCollectionByNameOrId("citations")

        pipeline.items.forEach((item, index) => {
          const digestItemRecord = new Record(digestItemsCollection)
          digestItemRecord.set("digest", persistedDigest.id)
          digestItemRecord.set("topic", item.topic)
          digestItemRecord.set("why_reason", item.whyReason)
          digestItemRecord.set("summary", item.summary)
          digestItemRecord.set("freshness_minutes", item.freshnessMinutes)
          digestItemRecord.set("rank", index + 1)
          txApp.save(digestItemRecord)

          const citationRecord = new Record(citationsCollection)
          citationRecord.set("digest_item", digestItemRecord.id)
          citationRecord.set("source_name", item.sourceName)
          citationRecord.set("canonical_url", item.canonicalUrl)
          citationRecord.set("published_at", item.publishedAt)
          txApp.save(citationRecord)
        })
      })
    } catch (error) {
      const existing = findDigestByKey(digestKey)
      if (existing) {
        return existing
      }
      fail(500, "PERSISTENCE_ERROR", "Failed to persist digest")
    }

    return persistedDigest
  }

  const parseBody = () => {
    const requestInfo = e.requestInfo()
    if (!requestInfo || requestInfo.body === undefined || requestInfo.body === null) {
      return {}
    }

    return asPlain(requestInfo.body, {})
  }

  const serializeProfile = (record) => ({
    id: record.id,
    userId: record.getString("user") || null,
    version: record.getInt("version"),
    topicPriorities: decodeJsonField(record.get("topic_priorities"), {}),
    hardFilters: asArray(decodeJsonField(record.get("hard_filters"), [])),
    sourceAllowlist: asArray(decodeJsonField(record.get("source_allowlist"), [])),
    sourceBlocklist: asArray(decodeJsonField(record.get("source_blocklist"), [])),
    tone: record.getString("tone"),
    frequency: record.getString("frequency"),
    length: record.getString("length"),
    rankingTweaks: decodeJsonField(record.get("ranking_tweaks"), {}),
    updatedAt: record.getString("updated_at"),
  })

  const listSavedDigests = (context) => {
    const limitRaw = e.request ? String(e.request.url.query().get("limit") || "") : ""
    const cursorRaw = e.request ? String(e.request.url.query().get("cursor") || "") : ""

    const requestedLimit = Number(limitRaw || runtimeConfig.savedDigestsDefaultLimit)
    if (Number.isNaN(requestedLimit) || requestedLimit <= 0) {
      fail(400, "BAD_REQUEST", "limit must be positive integer")
    }

    const effectiveMaxLimit = Math.max(runtimeConfig.savedDigestsMaxLimit, runtimeConfig.savedDigestsDefaultLimit)
    const limit = Math.min(requestedLimit, effectiveMaxLimit)

    const ownerFilter = context.mode === "guest" ? "user = ''" : "user = {:userId}"
    const params = context.mode === "guest" ? [] : [{ userId: context.userId }]

    let filter = `${ownerFilter} && saved = true`

    if (cursorRaw) {
      const parts = cursorRaw.split("|")
      if (parts.length !== 2 || !parts[0] || !parts[1]) {
        fail(400, "BAD_REQUEST", "cursor must be <generatedAt>|<digestId>")
      }

      filter = `${filter} && (generated_at < {:cursorGeneratedAt} || (generated_at = {:cursorGeneratedAt} && id < {:cursorId}))`
      params.push({
        cursorGeneratedAt: parts[0],
        cursorId: parts[1],
      })
    }

    const records = $app.findRecordsByFilter(
      "digests",
      filter,
      "-generated_at,-id",
      limit + 1,
      0,
      ...params,
    )

    const normalized = asArray(records)
    const hasMore = normalized.length > limit
    const pageRecords = hasMore ? normalized.slice(0, limit) : normalized

    const items = pageRecords.map((record) => serializeDigest(record))
    let nextCursor = null

    if (hasMore && pageRecords.length > 0) {
      const tail = pageRecords[pageRecords.length - 1]
      nextCursor = `${tail.getString("generated_at")}|${tail.id}`
    }

    return {
      items,
      nextCursor,
    }
  }

  try {
    const method = e.request ? String(e.request.method || "").toUpperCase() : ""
    const path = e.request ? String(e.request.url.path || "") : ""
    $app.logger().info(
      "psc_request",
      "context",
      JSON.stringify({
        traceId,
        method,
        path,
      }),
    )

    if (method === "GET" && path === "/v1/digests/latest") {
      const context = resolveContext()
      const profile = resolveProfile(context)
      const pipeline = buildPipeline(profile)

      const digestKey = buildDigestKey(
        context,
        profile.id,
        pipeline.nowIsoValue,
        pipeline.sourceSnapshotHash,
      )

      const existing = findDigestByKey(digestKey)
      if (existing) {
        assertDigestAccess(existing, context)
        respondJson(200, serializeDigest(existing))
        return
      }

      const created = persistDigest(profile, pipeline, digestKey, context)
      respondJson(200, serializeDigest(created))
      return
    }

    if (method === "GET" && path.startsWith("/v1/digests/")) {
      const digestId = path.replace("/v1/digests/", "").trim()
      if (!digestId) {
        fail(400, "BAD_REQUEST", "digestId path parameter is required")
      }

      const context = resolveContext()
      let digestRecord = null
      try {
        digestRecord = $app.findRecordById("digests", digestId)
      } catch (_) {
        fail(404, "NOT_FOUND", "Digest not found", { digestId })
      }

      assertDigestAccess(digestRecord, context)
      respondJson(200, serializeDigest(digestRecord))
      return
    }

    if (method === "POST" && path === "/v1/rules/profiles") {
      const context = resolveContext()
      const body = parseBody()
      const normalizedRule = normalizeRulePayload(body, defaults)
      validateRulePayload(normalizedRule)

      if (context.mode === "guest") {
        const scopedGuestProfile = ensureGuestProfile(context)
        const parsedVersion = Number(body.version)
        const nextVersion = Number.isNaN(parsedVersion)
          ? (scopedGuestProfile.getInt("version") + 1)
          : Math.max(scopedGuestProfile.getInt("version") + 1, Math.floor(parsedVersion))

        scopedGuestProfile.set("topic_priorities", normalizedRule.topic_priorities)
        scopedGuestProfile.set("hard_filters", normalizedRule.hard_filters)
        scopedGuestProfile.set("source_allowlist", normalizedRule.source_allowlist)
        scopedGuestProfile.set("source_blocklist", normalizedRule.source_blocklist)
        scopedGuestProfile.set("tone", normalizedRule.tone)
        scopedGuestProfile.set("frequency", normalizedRule.frequency)
        scopedGuestProfile.set("length", normalizedRule.length)
        scopedGuestProfile.set("ranking_tweaks", normalizedRule.ranking_tweaks)
        scopedGuestProfile.set("version", nextVersion)
        scopedGuestProfile.set("updated_at", nowIso())
        $app.save(scopedGuestProfile)

        respondJson(201, serializeProfile(scopedGuestProfile))
        return
      }

      const latestProfile = findLatestProfile(context)
      const parsedVersion = Number(body.version)
      const nextVersion = Number.isNaN(parsedVersion)
        ? ((latestProfile ? latestProfile.getInt("version") : 0) + 1)
        : Math.max(1, Math.floor(parsedVersion))

      const profileRecord = createProfileRecord(context, normalizedRule, nextVersion, "")
      respondJson(201, serializeProfile(profileRecord))
      return
    }

    if (method === "PATCH" && path.startsWith("/v1/rules/profiles/")) {
      const profileId = path.replace("/v1/rules/profiles/", "").trim()
      if (!profileId) {
        fail(400, "BAD_REQUEST", "profile id path parameter is required")
      }

      const context = resolveContext()
      const profileRecord = findProfileById(profileId)
      assertProfileAccess(profileRecord, context)

      if (context.mode === "guest") {
        const scopedGuestProfile = ensureGuestProfile(context)
        if (scopedGuestProfile.id !== profileId) {
          fail(403, "FORBIDDEN", "Guest mode can update only scoped guest profile")
        }
      }

      const body = parseBody()
      const mergedRule = normalizeRulePayload(body, {
        topic_priorities: decodeJsonField(profileRecord.get("topic_priorities"), {}),
        hard_filters: decodeJsonField(profileRecord.get("hard_filters"), []),
        source_allowlist: decodeJsonField(profileRecord.get("source_allowlist"), []),
        source_blocklist: decodeJsonField(profileRecord.get("source_blocklist"), []),
        tone: profileRecord.getString("tone"),
        frequency: profileRecord.getString("frequency"),
        length: profileRecord.getString("length"),
        ranking_tweaks: decodeJsonField(profileRecord.get("ranking_tweaks"), {}),
      })
      validateRulePayload(mergedRule)

      profileRecord.set("topic_priorities", mergedRule.topic_priorities)
      profileRecord.set("hard_filters", mergedRule.hard_filters)
      profileRecord.set("source_allowlist", mergedRule.source_allowlist)
      profileRecord.set("source_blocklist", mergedRule.source_blocklist)
      profileRecord.set("tone", mergedRule.tone)
      profileRecord.set("frequency", mergedRule.frequency)
      profileRecord.set("length", mergedRule.length)
      profileRecord.set("ranking_tweaks", mergedRule.ranking_tweaks)
      profileRecord.set("version", profileRecord.getInt("version") + 1)
      profileRecord.set("updated_at", nowIso())
      $app.save(profileRecord)

      respondJson(200, serializeProfile(profileRecord))
      return
    }

    if (method === "POST" && path === "/v1/feedback") {
      const context = resolveContext()
      const body = parseBody()
      const rating = Number(body.rating)

      if (Number.isNaN(rating) || rating < 1 || rating > 5) {
        fail(422, "VALIDATION_FAILED", "rating must be between 1 and 5")
      }

      const digestItemId = body.digestItemId ? String(body.digestItemId).trim() : ""
      if (digestItemId) {
        try {
          const digestItemRecord = $app.findRecordById("digest_items", digestItemId)
          const digestRecord = $app.findRecordById("digests", digestItemRecord.getString("digest"))
          assertDigestAccess(digestRecord, context)
        } catch (_) {
          fail(404, "NOT_FOUND", "digest item not found", { digestItemId })
        }
      }

      const feedbackCollection = $app.findCollectionByNameOrId("feedback_events")
      const feedbackRecord = new Record(feedbackCollection)
      feedbackRecord.set("user", context.userId)
      feedbackRecord.set("digest_item", digestItemId)
      feedbackRecord.set("rating", Math.round(rating))
      feedbackRecord.set("reason", body.reason ? String(body.reason).trim() : "")
      feedbackRecord.set("created_at", nowIso())
      $app.save(feedbackRecord)

      respondJson(201, {
        id: feedbackRecord.id,
        userId: feedbackRecord.getString("user") || null,
        digestItemId: feedbackRecord.getString("digest_item") || null,
        rating: feedbackRecord.getInt("rating"),
        reason: feedbackRecord.getString("reason"),
        createdAt: feedbackRecord.getString("created_at"),
      })
      return
    }

    if (method === "GET" && path === "/v1/saved-digests") {
      const context = resolveContext()
      respondJson(200, listSavedDigests(context))
      return
    }

    fail(404, "NOT_FOUND", "Route not found")
  } catch (error) {
    if (error && error.__psc) {
      sendError(
        Number(error.status || 500),
        String(error.code || "INTERNAL_ERROR"),
        String(error.message || "Request failed"),
        asPlain(error.details, {}),
      )
      return
    }

    sendError(500, "INTERNAL_ERROR", "Unexpected server error")
  }
}

routerAdd("GET", "/v1/{rest...}", pscApiHandler)
routerAdd("POST", "/v1/{rest...}", pscApiHandler)
routerAdd("PATCH", "/v1/{rest...}", pscApiHandler)

// Purpose: Read environment variable with fallback and no throwing side-effects.
function authReadEnv(name, fallbackValue) {
  const raw = $os.getenv(name)
  if (!raw || !String(raw).trim()) {
    return fallbackValue
  }

  return String(raw).trim()
}

// Purpose: Parse boolean-like environment values with explicit defaults.
function authBoolEnv(name, fallbackValue) {
  const raw = authReadEnv(name, "").toLowerCase()
  if (!raw) {
    return fallbackValue
  }

  return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
}

// Purpose: Parse positive integer environment values while preserving deterministic defaults.
function authPositiveIntEnv(name, fallbackValue) {
  const parsed = Number(authReadEnv(name, ""))
  if (Number.isNaN(parsed) || parsed <= 0) {
    return fallbackValue
  }

  return Math.floor(parsed)
}

var authPolicyConfig = Object.freeze({
  enabled: authBoolEnv("PSC_AUTH_POLICY_ENABLED", true),
  traceIdLength: authPositiveIntEnv("PSC_TRACE_ID_LENGTH", 24),
  loginWindowSeconds: authPositiveIntEnv("PSC_AUTH_LOGIN_WINDOW_SECONDS", 300),
  loginMaxAttempts: authPositiveIntEnv("PSC_AUTH_LOGIN_MAX_ATTEMPTS", 8),
  loginLockoutSeconds: authPositiveIntEnv("PSC_AUTH_LOGIN_LOCKOUT_SECONDS", 900),
  verifyResendWindowSeconds: authPositiveIntEnv("PSC_AUTH_VERIFY_RESEND_WINDOW_SECONDS", 600),
  verifyResendMaxAttempts: authPositiveIntEnv("PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS", 3),
  passwordResetWindowSeconds: authPositiveIntEnv("PSC_AUTH_PASSWORD_RESET_WINDOW_SECONDS", 600),
  passwordResetMaxAttempts: authPositiveIntEnv("PSC_AUTH_PASSWORD_RESET_MAX_ATTEMPTS", 3),
  verifyConfirmWindowSeconds: authPositiveIntEnv("PSC_AUTH_VERIFY_CONFIRM_WINDOW_SECONDS", 600),
  verifyConfirmMaxAttempts: authPositiveIntEnv("PSC_AUTH_VERIFY_CONFIRM_MAX_ATTEMPTS", 10),
  resetConfirmWindowSeconds: authPositiveIntEnv("PSC_AUTH_RESET_CONFIRM_WINDOW_SECONDS", 600),
  resetConfirmMaxAttempts: authPositiveIntEnv("PSC_AUTH_RESET_CONFIRM_MAX_ATTEMPTS", 10),
})

// Purpose: Generate compact deterministic trace IDs for auth policy logs and error payloads.
function authTraceId(event, action) {
  const path = event && event.request ? String(event.request.url.path || "") : ""
  const seed = `${Date.now()}|${Math.random()}|${action}|${path}`
  return $security.sha256(seed).slice(0, authPolicyConfig.traceIdLength)
}

// Purpose: Safely resolve request IP for rate-limit scope without exposing raw identifiers.
function authResolveIp(event) {
  try {
    const ip = event.realIP()
    return String(ip || "unknown")
  } catch (_) {
    return "unknown"
  }
}

function authHash(value) {
  return $security.sha256(String(value || "").trim().toLowerCase())
}

// Purpose: Return minimal error response compatible with client-safe auth surfaces.
function authReject(event, traceId, status, code, message, details) {
  event.json(status, {
    code,
    message,
    details: details || {},
    traceId,
  })
}

function authFindFirst(collectionName, filter, params) {
  try {
    return $app.findFirstRecordByFilter(collectionName, filter, params)
  } catch (_) {
    return null
  }
}

function authWindowBucket(windowSeconds, nowMs) {
  return `${windowSeconds}:${Math.floor(nowMs / (windowSeconds * 1000))}`
}

// Purpose: Increment per-window attempt counters for deterministic auth throttling.
function authIncrementRate(action, scopeKey, windowSeconds, nowIsoValue) {
  const nowMs = Date.parse(nowIsoValue)
  const bucket = authWindowBucket(windowSeconds, nowMs)
  const existing = authFindFirst(
    "auth_rate_limits",
    "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
    { action, scopeKey, bucket },
  )

  if (existing) {
    const attempts = existing.getInt("attempts") + 1
    existing.set("attempts", attempts)
    existing.set("updated_at", nowIsoValue)
    $app.save(existing)
    return attempts
  }

  const collection = $app.findCollectionByNameOrId("auth_rate_limits")
  const record = new Record(collection)
  record.set("action", action)
  record.set("scope_key", scopeKey)
  record.set("window_bucket", bucket)
  record.set("attempts", 1)
  record.set("updated_at", nowIsoValue)
  $app.save(record)
  return 1
}

// Purpose: Resolve active lockout state and cleanup expired lock records.
function authGetActiveLockout(action, scopeKey, nowMs) {
  const record = authFindFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", { action, scopeKey })
  if (!record) {
    return null
  }

  const lockedUntilIso = record.getString("locked_until")
  const lockedUntilMs = Date.parse(lockedUntilIso)
  if (Number.isNaN(lockedUntilMs) || lockedUntilMs <= nowMs) {
    try {
      $app.delete(record)
    } catch (_) {
      // Purposefully ignore cleanup errors to keep auth flow available.
    }
    return null
  }

  return {
    record,
    lockedUntilMs,
  }
}

// Purpose: Upsert lockout record when abuse threshold is crossed.
function authSetLockout(action, scopeKey, lockoutSeconds, failures, reason, nowIsoValue) {
  const nowMs = Date.parse(nowIsoValue)
  const lockedUntilIso = new Date(nowMs + (lockoutSeconds * 1000)).toISOString()

  const existing = authFindFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", { action, scopeKey })
  if (existing) {
    existing.set("locked_until", lockedUntilIso)
    existing.set("reason", reason || "")
    existing.set("failures", failures)
    existing.set("updated_at", nowIsoValue)
    $app.save(existing)
    return existing
  }

  const collection = $app.findCollectionByNameOrId("auth_lockouts")
  const record = new Record(collection)
  record.set("action", action)
  record.set("scope_key", scopeKey)
  record.set("locked_until", lockedUntilIso)
  record.set("reason", reason || "")
  record.set("failures", failures)
  record.set("updated_at", nowIsoValue)
  $app.save(record)
  return record
}

// Purpose: Remove stale lockout after successful authentication to minimize false positive friction.
function authClearLockout(action, scopeKey) {
  const existing = authFindFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", { action, scopeKey })
  if (!existing) {
    return
  }

  try {
    $app.delete(existing)
  } catch (_) {
    // Purposefully ignore clear errors to avoid blocking success path.
  }
}

// Purpose: Persist security-relevant auth events in a redacted, operator-focused audit collection.
function authAudit(input) {
  try {
    const collection = $app.findCollectionByNameOrId("auth_audit_logs")
    const record = new Record(collection)
    record.set("user", input.userId || "")
    record.set("action", input.action)
    record.set("success", Boolean(input.success))
    record.set("scope_key", input.scopeKey || "")
    record.set("ip", input.ipHash || "")
    record.set("identity_hash", input.identityHash || "")
    record.set("details", input.details || {})
    record.set("created_at", new Date().toISOString())
    $app.save(record)
  } catch (_) {
    $app.logger().warn("psc_auth_audit_skip", "context", JSON.stringify({ action: input.action || "unknown" }))
  }
}

function authLog(level, message, payload) {
  const context = JSON.stringify(payload || {})
  if (level === "error") {
    $app.logger().error(message, "context", context)
    return
  }

  if (level === "warn") {
    $app.logger().warn(message, "context", context)
    return
  }

  $app.logger().info(message, "context", context)
}

function authHandleRateLimitFailure(input) {
  authLog("warn", "psc_auth_policy_block", {
    traceId: input.traceId,
    action: input.action,
    code: input.code,
    scopeKey: input.scopeKey,
    attempts: input.attempts,
    retryAfterSeconds: input.retryAfterSeconds,
    path: input.event && input.event.request ? String(input.event.request.url.path || "") : "",
  })
  authAudit({
    action: input.action,
    success: false,
    scopeKey: input.scopeKey,
    ipHash: input.ipHash,
    identityHash: input.identityHash,
    userId: "",
    details: {
      code: input.code,
      attempts: input.attempts,
      retryAfterSeconds: input.retryAfterSeconds,
      traceId: input.traceId,
    },
  })
  authReject(input.event, input.traceId, 429, input.code, input.message, {
    retryAfterSeconds: input.retryAfterSeconds,
  })
}

function authScope(label, key, lockoutEligible) {
  return {
    label,
    key,
    lockoutEligible: Boolean(lockoutEligible),
  }
}

// Purpose: Enforce action-specific throttling policy with acyclic stage order:
// active lockout check -> rate increment -> threshold decision -> optional lockout.
function authEnforce(event, action, options) {
  if (!authPolicyConfig.enabled) {
    return {
      allowed: true,
      traceId: "",
    }
  }

  const traceId = authTraceId(event, action)
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const ipHash = authHash(authResolveIp(event)).slice(0, 24)
  const identityHash = authHash(options.identityValue || "").slice(0, 24)
  const scopes = options.scopes.filter((entry) => entry && entry.key)

  if (scopes.length === 0) {
    return {
      allowed: true,
      traceId,
      identityHash,
      ipHash,
      scopes,
    }
  }

  for (const scopeEntry of scopes) {
    const activeLockout = authGetActiveLockout(action, scopeEntry.key, nowMs)
    if (!activeLockout) {
      continue
    }

    const retryAfterSeconds = Math.max(1, Math.ceil((activeLockout.lockedUntilMs - nowMs) / 1000))
    authHandleRateLimitFailure({
      event,
      traceId,
      action,
      scopeKey: scopeEntry.key,
      ipHash,
      identityHash,
      code: "AUTH_LOCKED",
      message: "Too many attempts. Please try again later.",
      retryAfterSeconds,
      attempts: -1,
    })
    return {
      allowed: false,
      traceId,
      identityHash,
      ipHash,
      scopes,
    }
  }

  let exceeded = null
  for (const scopeEntry of scopes) {
    const attempts = authIncrementRate(action, scopeEntry.key, options.windowSeconds, nowIsoValue)
    if (attempts > options.maxAttempts) {
      exceeded = {
        scopeEntry,
        attempts,
      }
      break
    }
  }

  if (!exceeded) {
    authLog("info", "psc_auth_policy_allow", {
      traceId,
      action,
      path: event && event.request ? String(event.request.url.path || "") : "",
    })
    return {
      allowed: true,
      traceId,
      identityHash,
      ipHash,
      scopes,
    }
  }

  if (options.lockoutSeconds > 0 && exceeded.scopeEntry.lockoutEligible) {
    authSetLockout(
      action,
      exceeded.scopeEntry.key,
      options.lockoutSeconds,
      exceeded.attempts,
      "threshold_exceeded",
      nowIsoValue,
    )
    authHandleRateLimitFailure({
      event,
      traceId,
      action,
      scopeKey: exceeded.scopeEntry.key,
      ipHash,
      identityHash,
      code: "AUTH_LOCKED",
      message: "Too many attempts. Please try again later.",
      retryAfterSeconds: options.lockoutSeconds,
      attempts: exceeded.attempts,
    })
    return {
      allowed: false,
      traceId,
      identityHash,
      ipHash,
      scopes,
    }
  }

  authHandleRateLimitFailure({
    event,
    traceId,
    action,
    scopeKey: exceeded.scopeEntry.key,
    ipHash,
    identityHash,
    code: "RATE_LIMITED",
    message: "Request rate exceeded. Please retry later.",
    retryAfterSeconds: options.windowSeconds,
    attempts: exceeded.attempts,
  })
  return {
    allowed: false,
    traceId,
    identityHash,
    ipHash,
    scopes,
  }
}

onRecordAuthWithPasswordRequest((e) => {
  const readInt = (name, fallbackValue) => {
    const parsed = Number($os.getenv(name) || "")
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }
    return Math.floor(parsed)
  }
  const readBool = (name, fallbackValue) => {
    const raw = String($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return fallbackValue
    }
    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }
  const enabled = readBool("PSC_AUTH_POLICY_ENABLED", true)
  if (!enabled) {
    e.next()
    return
  }

  const hash = (value) => $security.sha256(String(value || "").trim().toLowerCase()).slice(0, 24)
  const findFirst = (collectionName, filter, params) => {
    try {
      return $app.findFirstRecordByFilter(collectionName, filter, params)
    } catch (_) {
      return null
    }
  }
  const traceId = $security
    .sha256(`${Date.now()}|${Math.random()}|login|${String(e.request ? e.request.url.path || "" : "")}`)
    .slice(0, readInt("PSC_TRACE_ID_LENGTH", 24))
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const loginWindowSeconds = readInt("PSC_AUTH_LOGIN_WINDOW_SECONDS", 300)
  const loginMaxAttempts = readInt("PSC_AUTH_LOGIN_MAX_ATTEMPTS", 8)
  const loginLockoutSeconds = readInt("PSC_AUTH_LOGIN_LOCKOUT_SECONDS", 900)

  const reject = (code, message, retryAfterSeconds) => {
    e.json(429, {
      code,
      message,
      details: {
        retryAfterSeconds,
      },
      traceId,
    })
  }

  const upsertRate = (scopeKey) => {
    const windowBucket = `${loginWindowSeconds}:${Math.floor(nowMs / (loginWindowSeconds * 1000))}`
    const existing = findFirst(
      "auth_rate_limits",
      "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
      {
        action: "login",
        scopeKey,
        bucket: windowBucket,
      },
    )

    if (existing) {
      const attempts = existing.getInt("attempts") + 1
      existing.set("attempts", attempts)
      existing.set("updated_at", nowIsoValue)
      $app.save(existing)
      return attempts
    }

    const collection = $app.findCollectionByNameOrId("auth_rate_limits")
    const record = new Record(collection)
    record.set("action", "login")
    record.set("scope_key", scopeKey)
    record.set("window_bucket", windowBucket)
    record.set("attempts", 1)
    record.set("updated_at", nowIsoValue)
    $app.save(record)
    return 1
  }

  const setLockout = (scopeKey, failures) => {
    const existing = findFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", {
      action: "login",
      scopeKey,
    })
    const lockedUntil = new Date(nowMs + (loginLockoutSeconds * 1000)).toISOString()

    if (existing) {
      existing.set("locked_until", lockedUntil)
      existing.set("reason", "threshold_exceeded")
      existing.set("failures", failures)
      existing.set("updated_at", nowIsoValue)
      $app.save(existing)
      return
    }

    const collection = $app.findCollectionByNameOrId("auth_lockouts")
    const record = new Record(collection)
    record.set("action", "login")
    record.set("scope_key", scopeKey)
    record.set("locked_until", lockedUntil)
    record.set("reason", "threshold_exceeded")
    record.set("failures", failures)
    record.set("updated_at", nowIsoValue)
    $app.save(record)
  }

  const clearLockout = (scopeKey) => {
    const existing = findFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", {
      action: "login",
      scopeKey,
    })
    if (!existing) {
      return
    }

    try {
      $app.delete(existing)
    } catch (_) {
      // ignore
    }
  }

  const appendAudit = (success, scopeKey, ipHash, identityHash, userId, details) => {
    try {
      const collection = $app.findCollectionByNameOrId("auth_audit_logs")
      const record = new Record(collection)
      record.set("user", userId || "")
      record.set("action", "login")
      record.set("success", Boolean(success))
      record.set("scope_key", scopeKey)
      record.set("ip", ipHash)
      record.set("identity_hash", identityHash)
      record.set("details", details || {})
      record.set("created_at", new Date().toISOString())
      $app.save(record)
    } catch (_) {
      // ignore
    }
  }

  const normalizedIdentity = String(e.identity || "").trim().toLowerCase()
  const identityHash = hash(normalizedIdentity || "missing")
  const ipHash = hash((() => {
    try {
      return e.realIP()
    } catch (_) {
      return "unknown"
    }
  })())
  const identityScope = `identity:${identityHash}`
  const ipScope = `ip:${ipHash}`

  const activeLockout = findFirst("auth_lockouts", "action = {:action} && scope_key = {:scopeKey}", {
    action: "login",
    scopeKey: identityScope,
  })
  if (activeLockout) {
    const lockUntilMs = Date.parse(activeLockout.getString("locked_until"))
    if (!Number.isNaN(lockUntilMs) && lockUntilMs > nowMs) {
      const retryAfterSeconds = Math.max(1, Math.ceil((lockUntilMs - nowMs) / 1000))
      appendAudit(false, identityScope, ipHash, identityHash, "", {
        traceId,
        code: "AUTH_LOCKED",
        retryAfterSeconds,
      })
      reject("AUTH_LOCKED", "Too many attempts. Please try again later.", retryAfterSeconds)
      return
    }
  }

  const identityAttempts = upsertRate(identityScope)
  const ipAttempts = upsertRate(ipScope)
  const highestAttempts = Math.max(identityAttempts, ipAttempts)
  if (highestAttempts > loginMaxAttempts) {
    if (identityAttempts > loginMaxAttempts) {
      setLockout(identityScope, identityAttempts)
      appendAudit(false, identityScope, ipHash, identityHash, "", {
        traceId,
        code: "AUTH_LOCKED",
        attempts: highestAttempts,
        retryAfterSeconds: loginLockoutSeconds,
      })
      reject("AUTH_LOCKED", "Too many attempts. Please try again later.", loginLockoutSeconds)
      return
    }

    appendAudit(false, ipScope, ipHash, identityHash, "", {
      traceId,
      code: "RATE_LIMITED",
      attempts: highestAttempts,
      retryAfterSeconds: loginWindowSeconds,
    })
    reject("RATE_LIMITED", "Request rate exceeded. Please retry later.", loginWindowSeconds)
    return
  }

  const startedAt = Date.now()
  try {
    e.next()
    const success = Boolean(e.record && e.record.id)
    if (success) {
      clearLockout(identityScope)
    }
    appendAudit(success, identityScope, ipHash, identityHash, success ? e.record.id : "", {
      traceId,
      durationMs: Date.now() - startedAt,
    })
  } catch (error) {
    appendAudit(false, identityScope, ipHash, identityHash, "", {
      traceId,
      durationMs: Date.now() - startedAt,
    })
    throw error
  }
}, "users")

onRecordRequestVerificationRequest((e) => {
  const readInt = (name, fallbackValue) => {
    const parsed = Number($os.getenv(name) || "")
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }
    return Math.floor(parsed)
  }
  const readBool = (name, fallbackValue) => {
    const raw = String($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return fallbackValue
    }
    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }
  if (!readBool("PSC_AUTH_POLICY_ENABLED", true)) {
    e.next()
    return
  }

  const windowSeconds = readInt("PSC_AUTH_VERIFY_RESEND_WINDOW_SECONDS", 600)
  const maxAttempts = readInt("PSC_AUTH_VERIFY_RESEND_MAX_ATTEMPTS", 3)
  const traceId = $security
    .sha256(`${Date.now()}|${Math.random()}|verify_resend`)
    .slice(0, readInt("PSC_TRACE_ID_LENGTH", 24))
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const hash = (value) => $security.sha256(String(value || "").trim().toLowerCase()).slice(0, 24)
  const ipHash = hash((() => {
    try {
      return e.realIP()
    } catch (_) {
      return "unknown"
    }
  })())
  const scopeKey = `ip:${ipHash}`
  const bucket = `${windowSeconds}:${Math.floor(nowMs / (windowSeconds * 1000))}`

  const findFirst = (collectionName, filter, params) => {
    try {
      return $app.findFirstRecordByFilter(collectionName, filter, params)
    } catch (_) {
      return null
    }
  }

  const existing = findFirst(
    "auth_rate_limits",
    "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
    { action: "verify_resend", scopeKey, bucket },
  )

  let attempts = 1
  if (existing) {
    attempts = existing.getInt("attempts") + 1
    existing.set("attempts", attempts)
    existing.set("updated_at", nowIsoValue)
    $app.save(existing)
  } else {
    const rateCollection = $app.findCollectionByNameOrId("auth_rate_limits")
    const rateRecord = new Record(rateCollection)
    rateRecord.set("action", "verify_resend")
    rateRecord.set("scope_key", scopeKey)
    rateRecord.set("window_bucket", bucket)
    rateRecord.set("attempts", attempts)
    rateRecord.set("updated_at", nowIsoValue)
    $app.save(rateRecord)
  }

  if (attempts > maxAttempts) {
    e.json(429, {
      code: "RATE_LIMITED",
      message: "Request rate exceeded. Please retry later.",
      details: {
        retryAfterSeconds: windowSeconds,
      },
      traceId,
    })
    return
  }

  e.next()
}, "users")

onRecordRequestPasswordResetRequest((e) => {
  const readInt = (name, fallbackValue) => {
    const parsed = Number($os.getenv(name) || "")
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }
    return Math.floor(parsed)
  }
  const readBool = (name, fallbackValue) => {
    const raw = String($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return fallbackValue
    }
    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }
  if (!readBool("PSC_AUTH_POLICY_ENABLED", true)) {
    e.next()
    return
  }

  const windowSeconds = readInt("PSC_AUTH_PASSWORD_RESET_WINDOW_SECONDS", 600)
  const maxAttempts = readInt("PSC_AUTH_PASSWORD_RESET_MAX_ATTEMPTS", 3)
  const traceId = $security
    .sha256(`${Date.now()}|${Math.random()}|password_reset`)
    .slice(0, readInt("PSC_TRACE_ID_LENGTH", 24))
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const hash = (value) => $security.sha256(String(value || "").trim().toLowerCase()).slice(0, 24)
  const ipHash = hash((() => {
    try {
      return e.realIP()
    } catch (_) {
      return "unknown"
    }
  })())
  const scopeKey = `ip:${ipHash}`
  const bucket = `${windowSeconds}:${Math.floor(nowMs / (windowSeconds * 1000))}`

  const findFirst = (collectionName, filter, params) => {
    try {
      return $app.findFirstRecordByFilter(collectionName, filter, params)
    } catch (_) {
      return null
    }
  }

  const existing = findFirst(
    "auth_rate_limits",
    "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
    { action: "password_reset", scopeKey, bucket },
  )

  let attempts = 1
  if (existing) {
    attempts = existing.getInt("attempts") + 1
    existing.set("attempts", attempts)
    existing.set("updated_at", nowIsoValue)
    $app.save(existing)
  } else {
    const rateCollection = $app.findCollectionByNameOrId("auth_rate_limits")
    const rateRecord = new Record(rateCollection)
    rateRecord.set("action", "password_reset")
    rateRecord.set("scope_key", scopeKey)
    rateRecord.set("window_bucket", bucket)
    rateRecord.set("attempts", attempts)
    rateRecord.set("updated_at", nowIsoValue)
    $app.save(rateRecord)
  }

  if (attempts > maxAttempts) {
    e.json(429, {
      code: "RATE_LIMITED",
      message: "Request rate exceeded. Please retry later.",
      details: {
        retryAfterSeconds: windowSeconds,
      },
      traceId,
    })
    return
  }

  e.next()
}, "users")

onRecordConfirmVerificationRequest((e) => {
  const readInt = (name, fallbackValue) => {
    const parsed = Number($os.getenv(name) || "")
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }
    return Math.floor(parsed)
  }
  const readBool = (name, fallbackValue) => {
    const raw = String($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return fallbackValue
    }
    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }
  if (!readBool("PSC_AUTH_POLICY_ENABLED", true)) {
    e.next()
    return
  }

  const windowSeconds = readInt("PSC_AUTH_VERIFY_CONFIRM_WINDOW_SECONDS", 600)
  const maxAttempts = readInt("PSC_AUTH_VERIFY_CONFIRM_MAX_ATTEMPTS", 10)
  const traceId = $security
    .sha256(`${Date.now()}|${Math.random()}|verify_confirm`)
    .slice(0, readInt("PSC_TRACE_ID_LENGTH", 24))
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const hash = (value) => $security.sha256(String(value || "").trim().toLowerCase()).slice(0, 24)
  const requestInfo = e.requestInfo()
  const token = requestInfo && requestInfo.body ? String(requestInfo.body.token || "").trim() : ""
  const tokenHash = hash(token || "missing-token")
  const ipHash = hash((() => {
    try {
      return e.realIP()
    } catch (_) {
      return "unknown"
    }
  })())
  const scopes = [`ip:${ipHash}`, `token:${tokenHash}`]
  const bucket = `${windowSeconds}:${Math.floor(nowMs / (windowSeconds * 1000))}`

  const findFirst = (collectionName, filter, params) => {
    try {
      return $app.findFirstRecordByFilter(collectionName, filter, params)
    } catch (_) {
      return null
    }
  }

  for (const scopeKey of scopes) {
    const existing = findFirst(
      "auth_rate_limits",
      "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
      { action: "verify_confirm", scopeKey, bucket },
    )

    let attempts = 1
    if (existing) {
      attempts = existing.getInt("attempts") + 1
      existing.set("attempts", attempts)
      existing.set("updated_at", nowIsoValue)
      $app.save(existing)
    } else {
      const rateCollection = $app.findCollectionByNameOrId("auth_rate_limits")
      const rateRecord = new Record(rateCollection)
      rateRecord.set("action", "verify_confirm")
      rateRecord.set("scope_key", scopeKey)
      rateRecord.set("window_bucket", bucket)
      rateRecord.set("attempts", attempts)
      rateRecord.set("updated_at", nowIsoValue)
      $app.save(rateRecord)
    }

    if (attempts > maxAttempts) {
      e.json(429, {
        code: "RATE_LIMITED",
        message: "Request rate exceeded. Please retry later.",
        details: {
          retryAfterSeconds: windowSeconds,
        },
        traceId,
      })
      return
    }
  }

  e.next()
}, "users")

onRecordConfirmPasswordResetRequest((e) => {
  const readInt = (name, fallbackValue) => {
    const parsed = Number($os.getenv(name) || "")
    if (Number.isNaN(parsed) || parsed <= 0) {
      return fallbackValue
    }
    return Math.floor(parsed)
  }
  const readBool = (name, fallbackValue) => {
    const raw = String($os.getenv(name) || "").trim().toLowerCase()
    if (!raw) {
      return fallbackValue
    }
    return raw === "1" || raw === "true" || raw === "yes" || raw === "on"
  }
  if (!readBool("PSC_AUTH_POLICY_ENABLED", true)) {
    e.next()
    return
  }

  const windowSeconds = readInt("PSC_AUTH_RESET_CONFIRM_WINDOW_SECONDS", 600)
  const maxAttempts = readInt("PSC_AUTH_RESET_CONFIRM_MAX_ATTEMPTS", 10)
  const traceId = $security
    .sha256(`${Date.now()}|${Math.random()}|reset_confirm`)
    .slice(0, readInt("PSC_TRACE_ID_LENGTH", 24))
  const nowIsoValue = new Date().toISOString()
  const nowMs = Date.parse(nowIsoValue)
  const hash = (value) => $security.sha256(String(value || "").trim().toLowerCase()).slice(0, 24)
  const requestInfo = e.requestInfo()
  const token = requestInfo && requestInfo.body ? String(requestInfo.body.token || "").trim() : ""
  const tokenHash = hash(token || "missing-token")
  const ipHash = hash((() => {
    try {
      return e.realIP()
    } catch (_) {
      return "unknown"
    }
  })())
  const scopes = [`ip:${ipHash}`, `token:${tokenHash}`]
  const bucket = `${windowSeconds}:${Math.floor(nowMs / (windowSeconds * 1000))}`

  const findFirst = (collectionName, filter, params) => {
    try {
      return $app.findFirstRecordByFilter(collectionName, filter, params)
    } catch (_) {
      return null
    }
  }

  for (const scopeKey of scopes) {
    const existing = findFirst(
      "auth_rate_limits",
      "action = {:action} && scope_key = {:scopeKey} && window_bucket = {:bucket}",
      { action: "reset_confirm", scopeKey, bucket },
    )

    let attempts = 1
    if (existing) {
      attempts = existing.getInt("attempts") + 1
      existing.set("attempts", attempts)
      existing.set("updated_at", nowIsoValue)
      $app.save(existing)
    } else {
      const rateCollection = $app.findCollectionByNameOrId("auth_rate_limits")
      const rateRecord = new Record(rateCollection)
      rateRecord.set("action", "reset_confirm")
      rateRecord.set("scope_key", scopeKey)
      rateRecord.set("window_bucket", bucket)
      rateRecord.set("attempts", attempts)
      rateRecord.set("updated_at", nowIsoValue)
      $app.save(rateRecord)
    }

    if (attempts > maxAttempts) {
      e.json(429, {
        code: "RATE_LIMITED",
        message: "Request rate exceeded. Please retry later.",
        details: {
          retryAfterSeconds: windowSeconds,
        },
        traceId,
      })
      return
    }
  }

  e.next()
}, "users")
