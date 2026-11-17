extends CharacterBody2D

const SPEED = 200.0
var knockback = Vector2.ZERO
var t = 0.0

func _ready():
	var m = CanvasItemMaterial.new()
	m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = m

func _physics_process(delta):
	var direction = (Input.get_vector("move_left", "move_right", "move_up", "move_down") + Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")).limit_length(1.0)
	velocity = direction * SPEED + knockback
	knockback = knockback.move_toward(Vector2.ZERO, 900.0 * delta)
	move_and_slide()

func _process(delta):
	t += delta
	queue_redraw()

func _draw():
	var pulse = 1.0 + 0.1 * sin(t * 6.0)
	draw_circle(Vector2.ZERO, 22 * pulse, Color(0.1, 0.9, 1.0, 0.06))
	draw_circle(Vector2.ZERO, 16 * pulse, Color(0.1, 0.9, 1.0, 0.15))
	draw_circle(Vector2.ZERO, 11, Color(0.1, 0.9, 1.0, 0.6))
	draw_circle(Vector2.ZERO, 6, Color(0.85, 1.0, 1.0))
