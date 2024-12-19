# kv_sessions_postgres_store

[![Package Version](https://img.shields.io/hexpm/v/kv_sessions_postgres_adapter)](https://hex.pm/packages/kv_sessions_postgres_adapter)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/kv_sessions_postgres_adapter/)

```sh
gleam add kv_sessions_postgres_store@1
```
```gleam
import kv_sessions/postgres_store

pub fn main() {
  let db = pog.default_config()
  |> pog.connect()
  
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

Further documentation can be found at <https://hexdocs.pm/kv_sessions_postgres_adapter>.
And <https://hexdocs.pm/kv_sessions>

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
