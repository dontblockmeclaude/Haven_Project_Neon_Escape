extends Node2D

const TILE = 40
const OFFSET = Vector2(140, 90)
const CUBE_SCENE = preload("res://scenes/cube.tscn")
const EXIT_SCENE = preload("res://scenes/Exit.tscn")
const HAZARD_SCENE = preload("res://scenes/Hazard.tscn")
const GLOW_SCRIPT = preload("res://scenes/MazeGlow.gd")

# # = wall, . = floor, P = player start, C = cube, E = exit, H = hazard orb
const LAYOUT = [
	"#########################",
	"#C#...H...#.....#.....#C#",
	"#.#.#####.#.###.#.#.#.#.#",
	"#...#...#.#..E#...#.#...#",
	"#####.#.#.#####.###.###.#",
	"#.....#.#..H..#...#.#...#",
	"#.###.#.#####.###...##.##",
	"#...#...#.....#C..#.....#",
	"#.#.###.#.###########.#.#",
	"#.....#.#.#....H....#.#.#",
	"#.#.###.#.###.#.#.#.###.#",
	"#...#...#...#.#...#...#.#",
	"###.#.###.#.###.#.##..#.#",
	"#P..#......H......#.....#",
	"#########################",
]

var cubes_collected = 0
const TOTAL_TIME = 90.0
var time_left = TOTAL_TIME
var last_sec = 90
var game_over = false
var invulnerable = false
var exit_node
var player_username: String = ""

@onready var timer_label = $HUD/TimerLabel
@onready var cube_label = $HUD/CubeLabel
@onready var message_label = $HUD/MessageLabel
@onready var end_screen = $EndScreen

func _ready():
	var config = ConfigFile.new()
	var config_error = config.load("user://player_settings.cfg")

	if config_error == OK:
		player_username = str(config.get_value("player", "username", ""))
	else:
		push_warning("Could not load player username.")

	for y in LAYOUT.size():
		for x in LAYOUT[y].length():
			var cell = LAYOUT[y][x]
			var pos = OFFSET + Vector2(x, y) * TILE
			var center = pos + Vector2(TILE, TILE) / 2
			if cell == "#":
				_make_wall(pos)
			elif cell == "C":
				_make_cube(center)
			elif cell == "E":
				_make_exit(center)
			elif cell == "H":
				_make_hazard(center)
			elif cell == "P":
				$Player.position = center
	cube_label.text = "CUBES: 0/3"
	message_label.text = ""
	_make_glow()

func _make_wall(pos):
	var body = StaticBody2D.new()
	body.position = pos
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(TILE, TILE)
	shape.shape = rect
	shape.position = Vector2(TILE, TILE) / 2
	body.add_child(shape)
	var visual = ColorRect.new()
	visual.size = Vector2(TILE, TILE)
	visual.color = Color(0.05, 0.04, 0.14)
	body.add_child(visual)
	add_child(body)

func _make_glow():
	var floor_rect = ColorRect.new()
	floor_rect.position = OFFSET
	floor_rect.size = Vector2(LAYOUT[0].length(), LAYOUT.size()) * TILE
	floor_rect.color = Color(0.035, 0.03, 0.09)
	floor_rect.z_index = -5
	add_child(floor_rect)
	var glow = GLOW_SCRIPT.new()
	glow.layout = LAYOUT
	glow.tile = TILE
	glow.offset = OFFSET
	glow.z_index = 1
	add_child(glow)

func _make_cube(pos):
	var cube = CUBE_SCENE.instantiate()
	cube.position = pos
	cube.collected.connect(_on_cube_collected)
	add_child(cube)

func _make_exit(pos):
	exit_node = EXIT_SCENE.instantiate()
	exit_node.position = pos
	exit_node.reached.connect(_on_exit_reached)
	exit_node.blocked.connect(_on_exit_blocked)
	add_child(exit_node)

func _make_hazard(pos):
	var hazard = HAZARD_SCENE.instantiate()
	hazard.position = pos
	hazard.add_collision_exception_with($Player)
	hazard.hit_player.connect(_on_player_hit)
	add_child(hazard)

func _on_player_hit(hazard):
	if invulnerable or game_over:
		return
	invulnerable = true
	Sfx.play("hit")
	time_left = maxf(time_left - 5.0, 0.0)
	$Player.knockback = ($Player.position - hazard.position).normalized() * 450.0
	$Player.modulate = Color(1, 0.2, 0.2)
	message_label.text = "HIT! -5 SECONDS"
	await get_tree().create_timer(1.0).timeout
	$Player.modulate = Color(1, 1, 1)
	invulnerable = false
	if not game_over:
		message_label.text = ""

func _on_cube_collected():
	cubes_collected += 1
	cube_label.text = "CUBES: %d/3" % cubes_collected
	if cubes_collected == 3:
		Sfx.play("unlock")
		exit_node.unlock()
		message_label.text = "EXIT UNLOCKED!"
		await get_tree().create_timer(1.5).timeout
		if not game_over:
			message_label.text = ""
	else:
		Sfx.play("pickup")

func _on_exit_reached():
	if game_over:
		return
	game_over = true

	var completion_time = TOTAL_TIME - time_left
	if player_username.length() >= 3:  # NEW
		Online.score_submitted.connect(func(ok): print("Score submitted: ", ok), CONNECT_ONE_SHOT)  # NEW
		Online.submit_score(player_username, completion_time)  # NEW

	Sfx.play("win")
	$Player.set_physics_process(false)
	message_label.text = ""
	await get_tree().create_timer(0.6).timeout
	end_screen.show_result(true, time_left, cubes_collected)

func _on_exit_blocked():
	if game_over:
		return
	Sfx.play("denied")
	message_label.text = "EXIT LOCKED - GET ALL 3 CUBES"
	await get_tree().create_timer(1.5).timeout
	if not game_over:
		message_label.text = ""

func _process(delta):
	if game_over:
		return
	time_left -= delta
	if time_left <= 0:
		time_left = 0
		_lose()
	var sec = int(ceil(time_left))
	if sec != last_sec:
		last_sec = sec
		if sec <= 10 and sec > 0:
			Sfx.play("tick", -6.0)
	timer_label.text = "TIME: %d" % sec

func _lose():
	game_over = true
	Sfx.play("lose")
	$Player.set_physics_process(false)
	message_label.text = ""
	await get_tree().create_timer(0.6).timeout
	end_screen.show_result(false, time_left, cubes_collected)
