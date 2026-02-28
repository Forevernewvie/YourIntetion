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
    // already removed
  }
}

migrate((app) => {
  const users = app.findCollectionByNameOrId("users")
  const superuserOnlyRule = "@request.auth.id != '' && @request.auth.collectionName = '_superusers'"

  upsertCollection(app, "auth_rate_limits", "base", (collection) => {
    collection.fields.add(
      new SelectField({
        name: "action",
        required: true,
        maxSelect: 1,
        values: ["login", "verify_resend", "password_reset", "verify_confirm", "reset_confirm"],
      }),
      new TextField({ name: "scope_key", required: true, min: 1, max: 240 }),
      new TextField({ name: "window_bucket", required: true, min: 1, max: 64 }),
      new NumberField({ name: "attempts", required: true, min: 0, max: 999999 }),
      new AutodateField({ name: "updated_at", onCreate: true, onUpdate: true }),
    )

    collection.indexes = [
      "CREATE UNIQUE INDEX IF NOT EXISTS idx_auth_rate_limits_unique ON auth_rate_limits (action, scope_key, window_bucket)",
      "CREATE INDEX IF NOT EXISTS idx_auth_rate_limits_updated ON auth_rate_limits (updated_at DESC)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  upsertCollection(app, "auth_lockouts", "base", (collection) => {
    collection.fields.add(
      new TextField({ name: "action", required: true, min: 1, max: 80 }),
      new TextField({ name: "scope_key", required: true, min: 1, max: 240 }),
      new DateField({ name: "locked_until", required: true }),
      new TextField({ name: "reason", required: false, min: 0, max: 240 }),
      new NumberField({ name: "failures", required: true, min: 0, max: 999999 }),
      new AutodateField({ name: "updated_at", onCreate: true, onUpdate: true }),
    )

    collection.indexes = [
      "CREATE UNIQUE INDEX IF NOT EXISTS idx_auth_lockouts_unique ON auth_lockouts (action, scope_key)",
      "CREATE INDEX IF NOT EXISTS idx_auth_lockouts_until ON auth_lockouts (locked_until)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })

  upsertCollection(app, "auth_audit_logs", "base", (collection) => {
    collection.fields.add(
      new RelationField({
        name: "user",
        collectionId: users.id,
        required: false,
        maxSelect: 1,
        cascadeDelete: false,
      }),
      new TextField({ name: "action", required: true, min: 1, max: 120 }),
      new BoolField({ name: "success", required: true }),
      new TextField({ name: "scope_key", required: false, min: 0, max: 240 }),
      new TextField({ name: "ip", required: false, min: 0, max: 120 }),
      new TextField({ name: "identity_hash", required: false, min: 0, max: 120 }),
      new JSONField({ name: "details", required: false, maxSize: 131072 }),
      new AutodateField({ name: "created_at", onCreate: true, onUpdate: false }),
    )

    collection.indexes = [
      "CREATE INDEX IF NOT EXISTS idx_auth_audit_logs_created ON auth_audit_logs (created_at DESC)",
      "CREATE INDEX IF NOT EXISTS idx_auth_audit_logs_action_created ON auth_audit_logs (action, created_at DESC)",
      "CREATE INDEX IF NOT EXISTS idx_auth_audit_logs_user_created ON auth_audit_logs (user, created_at DESC)",
    ]

    collection.listRule = superuserOnlyRule
    collection.viewRule = superuserOnlyRule
    collection.createRule = superuserOnlyRule
    collection.updateRule = superuserOnlyRule
    collection.deleteRule = superuserOnlyRule
  })
}, (app) => {
  deleteCollectionIfExists(app, "auth_audit_logs")
  deleteCollectionIfExists(app, "auth_lockouts")
  deleteCollectionIfExists(app, "auth_rate_limits")
})
