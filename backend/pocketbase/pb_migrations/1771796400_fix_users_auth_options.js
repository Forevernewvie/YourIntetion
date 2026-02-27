/// <reference path="../pb_data/types.d.ts" />

migrate((app) => {
  let users = null
  try {
    users = app.findCollectionByNameOrId("users")
  } catch (_) {
    return
  }

  users.type = "auth"
  users.authRule = ""
  users.manageRule = "@request.auth.id != '' && id = @request.auth.id"

  if (!users.passwordAuth) {
    users.passwordAuth = {}
  }
  users.passwordAuth.enabled = true
  users.passwordAuth.identityFields = ["email"]

  app.save(users)
}, (app) => {
  try {
    const users = app.findCollectionByNameOrId("users")
    users.authRule = ""
    app.save(users)
  } catch (_) {
    // ignore rollback if collection is missing
  }
})
