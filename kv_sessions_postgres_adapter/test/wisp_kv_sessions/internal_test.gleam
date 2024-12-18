import gleam/dict
import gleam/dynamic
import gleam/json
import gleeunit/should
import wisp_kv_sessions/internal

pub fn encode_data_test() {
  let data =
    dict.new()
    |> dict.insert("key_one", "value1")
    |> dict.insert(
      "key_two",
      json.to_string(json.object([#("value2.1", json.string("value2.2"))])),
    )
    |> dict.insert("key_three", "value3")

  let json = internal.encode_data(data)

  json
  |> json.to_string
  |> should.equal(
    "{\"key_one\":\"value1\",\"key_three\":\"value3\",\"key_two\":\"{\\\"value2.1\\\":\\\"value2.2\\\"}\"}",
  )

  json
  |> json.to_string
  |> json.decode(dynamic.dict(dynamic.string, dynamic.string))
  |> should.be_ok
  |> dict.get("key_one")
  |> should.be_ok
  |> should.equal("value1")

  json
  |> json.to_string
  |> json.decode(dynamic.dict(dynamic.string, dynamic.string))
  |> should.be_ok
  |> dict.get("key_two")
  |> should.be_ok
  |> should.equal("{\"value2.1\":\"value2.2\"}")

  json
  |> json.to_string
  |> internal.decode_data_from_string()
  |> should.be_ok
  |> should.equal(data)
}
