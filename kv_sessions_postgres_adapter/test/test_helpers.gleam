import envoy
import gleam/int
import gleam/io
import gleam/option
import gleam/result
import kv_sessions/postgres_adapter
import pog

pub fn new_db(f: fn(pog.Connection) -> Nil) {
  let db_host = envoy.get("DB_HOST") |> result.unwrap("127.0.0.1")
  let db_password =
    envoy.get("DB_PASSWORD") |> result.unwrap("mySuperSecretPassword!")
  let db_user = envoy.get("DB_USER") |> result.unwrap("postgres")
  let assert Ok(db_port) =
    envoy.get("DB_HOST_PORT") |> result.unwrap("5432") |> int.parse
  let db_name = envoy.get("DB_NAME") |> result.unwrap("postgres")

  io.debug(#(db_host, db_password, db_user, db_name))

  let db =
    pog.default_config()
    |> pog.host(db_host)
    |> pog.database(db_name)
    |> pog.port(db_port)
    |> pog.user(db_user)
    |> pog.password(option.Some(db_password))
    |> pog.pool_size(1)
    |> pog.connect()

  let assert Ok(_) = postgres_adapter.migrate_down(db)
  let assert Ok(_) = postgres_adapter.migrate_up(db)

  pog.transaction(db, fn(db) {
    f(db)
    Error("Rollback")
  })
}
