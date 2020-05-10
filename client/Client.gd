extends Node

const STORE_FILE = "user://store.ini"
const STORE_SECTION = "nakama"
const STORE_KEY = "session"

var session : NakamaSession = null

onready var client := Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")

func _ready():
	var cfg = ConfigFile.new()
	cfg.load(STORE_FILE)
	var token = cfg.get_value(STORE_SECTION, STORE_KEY, "")
	if token:
		var restored_session = NakamaClient.restore_session(token)
		if restored_session.valid and not restored_session.expired:
			session = restored_session
			return
	var deviceid = OS.get_unique_id() # This is not supported by Godot in HTML5, use a different way to generate an id, or a different authentication option.
	session = yield(client.authenticate_device_async(deviceid), "completed")
	if not session.is_exception():
		cfg.set_value(STORE_SECTION, STORE_KEY, session.token)
		cfg.save(STORE_FILE)
	print(session._to_string())
