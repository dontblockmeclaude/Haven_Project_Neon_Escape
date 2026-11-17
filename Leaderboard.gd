
extends Control

const MENU_PATH = "res://scenes/MainMenu.tscn"
const SAVE_PATH = "user://player_settings.cfg"
const MAX_ENTRIES = 10

var my_username = ""

func _ready():
	$BackButton.pressed.connect(_on_back)
	$RefreshButton.pressed.connect(_on_refresh)

	# Connect to the online leaderboard signals.
	if not Online.scores_loaded.is_connected(_on_scores_loaded):
		Online.scores_loaded.connect(_on_scores_loaded)

	if not Online.scores_failed.is_connected(_on_scores_failed):
		Online.scores_failed.connect(_on_scores_failed)

	# Load the current player's username.
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		my_username = str(config.get_value("player", "username", ""))

	_load_scores()

func _on_back():
	Sfx.play("click")
	get_tree().change_scene_to_file(MENU_PATH)

func _on_refresh():
	Sfx.play("click")
	_load_scores()

func _load_scores():
	show_scores([])
	$StatusLabel.text = "LOADING LEADERBOARD..."
	$RefreshButton.disabled = true

	# Request scores from Google Sheets.
	Online.fetch_scores()

func _on_scores_loaded(scores):
	$RefreshButton.disabled = false

	if scores.is_empty():
		show_scores([])
		$StatusLabel.text = "NO SCORES YET"
		return

	# Sort fastest completion times first.
	var ranked_scores = scores.duplicate()

	ranked_scores.sort_custom(
		func(a, b):
			return float(a.get("time", 999999999.0)) < float(b.get("time", 999999999.0))
	)

	# Display only the top 10.
	if ranked_scores.size() > MAX_ENTRIES:
		ranked_scores = ranked_scores.slice(0, MAX_ENTRIES)

	show_scores(ranked_scores)
	$StatusLabel.text = "TOP 10 PLAYERS | %d ENTRIES" % ranked_scores.size()

func _on_scores_failed(error_message):
	$RefreshButton.disabled = false
	$StatusLabel.text = str(error_message)

func show_scores(scores):
	for child in $Rows.get_children():
		child.queue_free()

	for i in scores.size():
		$Rows.add_child(_make_row(i + 1, scores[i]))

func _make_row(rank, entry):
	var row = HBoxContainer.new()

	var username = str(entry.get("username", "Unknown"))
	var completion_time = float(entry.get("time", 0.0))

	var color = Color.WHITE

	if rank == 1:
		color = Color("ffd700")
	elif rank == 2:
		color = Color("c0c0c0")
	elif rank == 3:
		color = Color("cd7f32")

	var display_name = username

	if username == my_username:
		display_name += " (YOU)"

	var texts = [
		"#%d" % rank,
		display_name,
		"%.2f s" % completion_time
	]

	var widths = [100, 340, 160]

	for j in 3:
		var label = Label.new()
		label.text = texts[j]
		label.custom_minimum_size = Vector2(widths[j], 0)
		label.add_theme_font_size_override("font_size", 26)
		label.add_theme_color_override("font_color", color)
		row.add_child(label)

	return row
