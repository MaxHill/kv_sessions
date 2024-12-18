import gleam/dict
import gleam/dynamic
import gleam/json
import gleam/list

// Encode/Decode rows
//--------------------

pub fn decode_session_row(data: dynamic.Dynamic) {
  data
  |> dynamic.from
  |> dynamic.tuple3(
    dynamic.string,
    dynamic.tuple2(
      dynamic.tuple3(dynamic.int, dynamic.int, dynamic.int),
      dynamic.tuple3(dynamic.int, dynamic.int, dynamic.int),
    ),
    dynamic.string,
  )
}

pub fn encode_data(data: dict.Dict(String, String)) {
  data
  |> dict.fold([], fn(acc, key, val) {
    acc |> list.append([#(key, json.string(val))])
  })
  |> json.object
}

fn decode_data(data: dynamic.Dynamic) {
  dynamic.from(data) |> dynamic.dict(dynamic.string, dynamic.string)
}

pub fn decode_data_from_string(str: String) {
  json.decode(from: str, using: decode_data)
}
