extends Area2D

signal reached
signal blocked

var unlocked = false
var t = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	var m = CanvasItemMaterial.new()
	m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = m

func _process(delta):
	t += delta
	queue_redraw()

func unlock():
	unlocked = true

func _on_body_entered(body):
	if body.name == "Player":
		if unlocked:
			reached.emit()
		else:
			blocked.emit()

func _draw():
	var c = Color("00ff99") if unlocked else Color("ff2e63")
	var speed = 2.5 if unlocked else 0.6
	var pulse = 1.0 + 0.12 * sin(t * (6.0 if unlocked else 3.0))
	draw_circle(Vector2.ZERO, 26 * pulse, Color(c, 0.07))
	draw_circle(Vector2.ZERO, 18 * pulse, Color(c, 0.14))
	draw_set_transform(Vector2.ZERO, t * speed, Vector2.ONE)
	draw_rect(Rect2(-13, -13, 26, 26), Color(c, 0.9), false, 2.0)
	draw_set_transform(Vector2.ZERO, -t * speed, Vector2.ONE)
	draw_rect(Rect2(-8, -8, 16, 16), Color(c, 0.6), false, 2.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if not unlocked:
		draw_line(Vector2(-5, -5), Vector2(5, 5), Color(c, 0.9), 2.0)
		draw_line(Vector2(-5, 5), Vector2(5, -5), Color(c, 0.9), 2.0)
