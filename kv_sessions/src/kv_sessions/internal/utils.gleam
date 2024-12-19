import birl
import birl/duration
import gleam/bit_array
import gleam/crypto
import gleam/http/request
import gleam/order
import gleam/result
import kv_sessions/session
import wisp

/// Inject a cookie into a request replacing if it already exists
/// This will NOT be persisted between requests
pub fn inject_session_cookie(
  cookie_name cookie_name: String,
  request req: wisp.Request,
  value session_id: session.SessionId,
  security security: wisp.Security,
) -> wisp.Request {
  let value = session.id_to_string(session_id)
  let value = case security {
    wisp.PlainText -> bit_array.base64_encode(<<value:utf8>>, False)
    wisp.Signed -> wisp.sign_message(req, <<value:utf8>>, crypto.Sha512)
  }
  req
  |> request.remove_cookie(cookie_name)
  |> request.set_cookie(cookie_name, value)
}

/// Add session cookie to response 
pub fn set_session_cookie(
  cookie_name: String,
  response: wisp.Response,
  req: wisp.Request,
  session: session.Session,
) {
  wisp.set_cookie(
    response,
    req,
    cookie_name,
    session.id_to_string(session.id),
    wisp.Signed,
    seconds_from_now(session.expires_at),
  )
}

fn seconds_from_now(time: #(#(Int, Int, Int), #(Int, Int, Int))) {
  time
  |> birl.from_erlang_universal_datetime
  |> birl.difference(birl.now())
  |> duration.blur_to(duration.Second)
}

/// Get session Id from cookie
pub fn get_session_id(cookie_name: String, req: wisp.Request) {
  wisp.get_cookie(req, cookie_name, wisp.Signed)
  |> result.replace_error(session.NoSessionError)
  |> result.map(session.id_from_string)
}

pub fn is_session_expired(session: session.Session) {
  let expiry = birl.from_erlang_universal_datetime(session.expires_at)
  case birl.compare(birl.now(), expiry) {
    order.Gt -> True
    _ -> False
  }
}
