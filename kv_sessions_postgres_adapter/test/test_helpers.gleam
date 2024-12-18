import gleam/erlang/os
import gleam/int
import gleam/io
import gleam/option
import gleam/result
import pog
import wisp_kv_sessions/postgres_adapter

pub fn new_db(f: fn(pog.Connection) -> Nil) {
  let db_host = os.get_env("DB_HOST") |> result.unwrap("127.0.0.1")
  let db_password =
    os.get_env("DB_PASSWORD") |> result.unwrap("mySuperSecretPassword!")
  let db_user = os.get_env("DB_USER") |> result.unwrap("postgres")
  let assert Ok(db_port) =
    os.get_env("DB_HOST_PORT") |> result.unwrap("5432") |> int.parse
  let db_name = os.get_env("DB_NAME") |> result.unwrap("postgres")

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
