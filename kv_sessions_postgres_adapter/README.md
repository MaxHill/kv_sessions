# wisp_kv_sessions_postgres_store

[![Package Version](https://img.shields.io/hexpm/v/wisp_kv_sessions_postgres_store)](https://hex.pm/packages/wisp_kv_sessions_postgres_store)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/wisp_kv_sessions_postgres_store/)

```sh
gleam add wisp_kv_sessions_postgres_store@1
```
```gleam
import wisp_kv_sessions/postgres_store

pub fn main() {
  let db = pgo.connect(pgo.default_config())
  
  // Migrate
  use _ <- result.try(postgres_store.migrate_up(conn))

  // Setup session_store
  use postgres_store <- result.map(postgres_store.try_create_session_store(conn))

  // Create session config
  let session_config =
    session_config.Config(
      default_expiry: session.ExpireIn(60 * 60),
      cookie_name: "SESSION_COOKIE",
      store: postgres_store,
    )

  //...
}
```

Further documentation can be found at <https://hexdocs.pm/wisp_kv_sessions_postgres_store>.
And <https://hexdocs.pm/wisp_kv_sessions>

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
