extends Control

const GAME_PATH = "res://scenes/Game.tscn"
const LEADERBOARD_PATH = "res://scenes/Leaderboard.tscn"  # NEW
const SAVE_PATH = "user://player_settings.cfg"

var username_dialog: AcceptDialog

func _ready():
	$HowToLabel.hide()

	$UsernameInput.placeholder_text = "ENTER YOUR USERNAME"
	$UsernameInput.max_length = 16

	$PlayButton.pressed.connect(_on_play)
	$LeaderboardButton.pressed.connect(_on_leaderboard)  # NEW
	$HowToButton.pressed.connect(_on_how_to)
	$QuitButton.pressed.connect(_on_quit)

	username_dialog = AcceptDialog.new()
	add_child(username_dialog)

	$PlayButton.grab_focus()

func _load_username():
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)

	if error == OK:
		$UsernameInput.text = str(
			config.get_value("player", "username", "")
		)

func _save_username(username):
	var config = ConfigFile.new()
	config.set_value("player", "username", username)

	return config.save(SAVE_PATH)

func _on_play():
	var username = $UsernameInput.text.strip_edges()

	if username.length() < 3:
		username_dialog.dialog_text = "Username must contain at least 3 characters."
		username_dialog.popup_centered()
		return

	Sfx.play("click")

	var error = _save_username(username)

	if error != OK:
		username_dialog.dialog_text = "Could not save username. Please try again."
		username_dialog.popup_centered()
		return

	get_tree().change_scene_to_file(GAME_PATH)

func _on_leaderboard():  # NEW
	Sfx.play("click")
	get_tree().change_scene_to_file(LEADERBOARD_PATH)

func _on_how_to():
	Sfx.play("click")
	$HowToLabel.visible = not $HowToLabel.visible

func _on_quit():
	Sfx.play("click")
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()
