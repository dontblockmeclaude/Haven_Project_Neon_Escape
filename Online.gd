extends Node

signal scores_loaded(scores)
signal scores_failed(message)
signal score_submitted(ok)

const URL = "https://script.google.com/macros/s/AKfycbxXnpCEG4XP0JdhOzWFgVKms7xAsgm8VlVU4zI7BNKiEXNGFRXu8wmQXGe8ebUoXAGq3g/exec"
const TIMEOUT = 10.0

func fetch_scores():
	_send(URL, _on_scores_done)

func submit_score(username, time):
	var query = "?action=submit&username=%s&time=%.2f" % [username.uri_encode(), time]
	_send(URL + query, _on_submit_done)

func _send(full_url, handler):
	var http = HTTPRequest.new()
	http.timeout = TIMEOUT
	add_child(http)
	http.request_completed.connect(handler.bind(http))
	var err = http.request(full_url)
	if err != OK:
		handler.call(HTTPRequest.RESULT_CANT_CONNECT, 0, [], PackedByteArray(), http)

func _parse(result, code, body):
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		return null
	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) != TYPE_DICTIONARY or not data.get("ok", false):
		return null
	return data

func _on_scores_done(result, code, _headers, body, http):
	http.queue_free()
	var data = _parse(result, code, body)
	if data == null or not data.has("scores"):
		scores_failed.emit("Could not load scores. Check your connection.")
		return
	scores_loaded.emit(data["scores"])

func _on_submit_done(result, code, _headers, body, http):
	http.queue_free()
	score_submitted.emit(_parse(result, code, body) != null)
