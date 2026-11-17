extends CanvasLayer

const MENU_PATH = "res://scenes/MainMenu.tscn"

func _ready():
	hide()
	$RestartButton.pressed.connect(_on_restart)
	$MenuButton.pressed.connect(_on_menu)

func show_result(won, time_left, cubes):
	if won:
		$Title.text = "YOU ESCAPED!"
		$Title.modulate = Color("00ff99")
		$Stats.text = "Time left: %d s\nCubes: %d/3" % [int(ceil(time_left)), cubes]
	else:
		$Title.text = "TIME'S UP!"
		$Title.modulate = Color("ff2e63")
		$Stats.text = "Cubes collected: %d/3" % cubes
	show()
	$RestartButton.grab_focus()

func _on_restart():
	Sfx.play("click")
	get_tree().reload_current_scene()

func _on_menu():
	Sfx.play("click")
	get_tree().change_scene_to_file(MENU_PATH)
