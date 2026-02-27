/// <reference path="../pb_data/types.d.ts" />

function ensureCollection(app, name, type) {
  let collection
  try {
    collection = app.findCollectionByNameOrId(name)
  } catch (_) {
    collection = new Collection({
      name,
      type,
    })
  }

  collection.type = type
  return collection
}

function upsertCollection(app, name, type, setupFn) {
  const collection = ensureCollection(app, name, type)
  setupFn(collection)
  app.save(collection)
  return collection
}

function deleteCollectionIfExists(app, name) {
  try {
    const collection = app.findCollectionByNameOrId(name)
    app.delete(collection)
  } catch (_) {
    // collection is already removed
  }
}

migrate((app) => {
  const ownAuthRule = "@request.auth.id != '' && id = @request.auth.id"

  const users = upsertCollection(app, "users", "auth", (collection) => {
    if (!collection.fields.getByName("name")) {
      collection.fields.add(new TextField({
        name: "name",
        required: false,
        min: 1,
        max: 120,
      }))
    }

    collection.authRule = ""
    collection.manageRule = ownAuthRule
    if (!collection.passwordAuth) {
      collection.passwordAuth = {}
    }
    collection.passwordAuth.enabled = true
    collection.passwordAuth.identityFields = ["email"]

    collection.listRule = ownAuthRule
    collection.viewRule = ownAuthRule
    collection.createRule = ""
    collection.updateRule = ownAuthRule
    collection.deleteRule = ownAuthRule
  })

  const userCollectionId = users.id
  const superuserOnlyRule = "@request.auth.id != '' && @request.auth.collectionName = '_superusers'"

  const ruleProfiles = upsertCollection(app, "rule_profiles", "base", (collection) => {
    collection.fields.add(
      new RelationField({ name: "user", collectionId: userCollectionId, required: false, maxSelect: 1, cascadeDelete: false }),
      new NumberField({ name: "version", required: true, min: 1 }),
      new JSONField({ name: "topic_priorities", required: true, maxSize: 262144 }),
      new JSONField({ name: "hard_filters", required: false, maxSize: 262144 }),
      new JSONField({ name: "source_allowlist", required: false, maxSize: 262144 }),
      new JSONField({ name: "source_blocklist", required: false, maxSize: 262144 }),
      new SelectField({ name: "tone", required: true, maxSelect: 1, values: ["neutral", "analytical", "optimistic", "critical", "executive"] }),
      new SelectField({ name: "frequency", required: true, maxSelect: 1, values: ["daily", "weekdays", "threePerWeek"] }),
      new SelectField({ name: "length", required: true, maxSelect: 1, values: ["quick", "standard", "deep"] }),
      new JSONField({ name: "ranking_tweaks", required: true, maxSize: 262144 }),
      new AutodateField({ name: "updated_at", onCreate: true, onUpdate: true }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_rule_profiles_user_updated ON rule_profiles (user, updated_at DESC)",
      "CREATE UNIQUE INDEX IF NOT EXISTS idx_rule_profiles_user_version_unique ON rule_profiles (user, version) WHERE user != ''",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  const sourceEntries = upsertCollection(app, "source_entries", "base", (collection) => {
    collection.fields.add(
      new TextField({ name: "source_name", required: true, min: 1, max: 200 }),
      new SelectField({ name: "source_type", required: true, maxSelect: 1, values: ["news", "video", "community"] }),
      new TextField({ name: "source_domain", required: true, min: 1, max: 200 }),
      new TextField({ name: "topic", required: true, min: 1, max: 120 }),
      new TextField({ name: "title", required: true, min: 1, max: 400 }),
      new TextField({ name: "content_snippet", required: true, min: 1, max: 2000 }),
      new URLField({ name: "canonical_url", required: true }),
      new DateField({ name: "published_at", required: true }),
      new NumberField({ name: "trust_score", required: true, min: 0, max: 100 }),
      new JSONField({ name: "tags", required: true, maxSize: 131072 }),
      new BoolField({ name: "blocked", required: false }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_source_entries_published_desc ON source_entries (published_at DESC)",
      "CREATE INDEX IF NOT EXISTS idx_source_entries_topic_published ON source_entries (topic, published_at DESC)",
      "CREATE INDEX IF NOT EXISTS idx_source_entries_domain ON source_entries (source_domain)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  const digests = upsertCollection(app, "digests", "base", (collection) => {
    collection.fields.add(
      new RelationField({ name: "user", collectionId: userCollectionId, required: false, maxSelect: 1, cascadeDelete: false }),
      new RelationField({ name: "profile", collectionId: ruleProfiles.id, required: true, maxSelect: 1, cascadeDelete: false }),
      new TextField({ name: "digest_key", required: true, min: 8, max: 180 }),
      new DateField({ name: "generated_at", required: true }),
      new NumberField({ name: "quality_score", required: false, min: 0, max: 1 }),
      new BoolField({ name: "saved", required: false }),
    )

    collection.indexes = [
      "CREATE UNIQUE INDEX IF NOT EXISTS idx_digests_digest_key_unique ON digests (digest_key)",
      "CREATE INDEX IF NOT EXISTS idx_digests_profile_generated ON digests (profile, generated_at DESC)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  const digestItems = upsertCollection(app, "digest_items", "base", (collection) => {
    collection.fields.add(
      new RelationField({ name: "digest", collectionId: digests.id, required: true, maxSelect: 1, cascadeDelete: true }),
      new TextField({ name: "topic", required: true, min: 1, max: 120 }),
      new TextField({ name: "why_reason", required: true, min: 1, max: 400 }),
      new TextField({ name: "summary", required: true, min: 1, max: 3000 }),
      new NumberField({ name: "freshness_minutes", required: false, min: 0, max: 43200 }),
      new NumberField({ name: "rank", required: true, min: 1, max: 9999 }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_digest_items_digest_rank ON digest_items (digest, rank)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  upsertCollection(app, "citations", "base", (collection) => {
    collection.fields.add(
      new RelationField({ name: "digest_item", collectionId: digestItems.id, required: true, maxSelect: 1, cascadeDelete: true }),
      new TextField({ name: "source_name", required: true, min: 1, max: 200 }),
      new URLField({ name: "canonical_url", required: true }),
      new DateField({ name: "published_at", required: true }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_citations_digest_item ON citations (digest_item)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  upsertCollection(app, "feedback_events", "base", (collection) => {
    collection.fields.add(
      new RelationField({ name: "user", collectionId: userCollectionId, required: false, maxSelect: 1, cascadeDelete: false }),
      new RelationField({ name: "digest_item", collectionId: digestItems.id, required: false, maxSelect: 1, cascadeDelete: false }),
      new NumberField({ name: "rating", required: true, min: 1, max: 5 }),
      new TextField({ name: "reason", required: false, min: 0, max: 500 }),
      new AutodateField({ name: "created_at", onCreate: true, onUpdate: false }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_feedback_created_desc ON feedback_events (created_at DESC)",
      "CREATE INDEX IF NOT EXISTS idx_feedback_user_created ON feedback_events (user, created_at DESC)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  // Keep lints happy by marking values as used in migration scope.
  void sourceEntries
}, (app) => {
  deleteCollectionIfExists(app, "feedback_events")
  deleteCollectionIfExists(app, "citations")
  deleteCollectionIfExists(app, "digest_items")
  deleteCollectionIfExists(app, "digests")
  deleteCollectionIfExists(app, "source_entries")
  deleteCollectionIfExists(app, "rule_profiles")
  deleteCollectionIfExists(app, "users")
})
