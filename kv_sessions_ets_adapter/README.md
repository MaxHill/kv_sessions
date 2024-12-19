# kv_sessions_ets_store

[![Package Version](https://img.shields.io/hexpm/v/kv_sessions_ets_store)](https://hex.pm/packages/kv_sessions_ets_store)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/kv_sessions_ets_store/)

```sh
gleam add kv_sessions_ets_store@1
```
```gleam
import kv_sessions/ets_store

pub fn main() {
  // Setup session_store
  use ets_store <- result.map(ets_store.try_create_session_store("sessions_table"))

  // Create session config
  let session_config =
    session_config.Config(
      default_expiry: session.ExpireIn(60 * 60),
      cookie_name: "SESSION_COOKIE",
      store: ets_store,
    )

  //...
}
```

Further documentation can be found at <https://hexdocs.pm/kv_sessions_ets_store>.
And <https://hexdocs.pm/kv_sessions>

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
