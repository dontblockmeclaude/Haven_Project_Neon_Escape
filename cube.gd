extends Area2D

signal collected

var t = randf() * 10.0

func _ready():
	body_entered.connect(_on_body_entered)
	var m = CanvasItemMaterial.new()
	m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = m

func _process(delta):
	t += delta
	queue_redraw()

func _on_body_entered(body):
	if body.name == "Player":
		collected.emit()
		queue_free()

func _draw():
	var bob = Vector2(0, sin(t * 3.0) * 2.0)
	var col = Color(1.0, 0.9, 0.25)
	var pts = []
	for i in 8:
		var v = Vector3(
			1.0 if (i & 4) != 0 else -1.0,
			1.0 if (i & 2) != 0 else -1.0,
			1.0 if (i & 1) != 0 else -1.0)
		v = v.rotated(Vector3.UP, t * 1.5).rotated(Vector3.RIGHT, 0.6)
		pts.append(Vector2(v.x, v.y) * 8.0 + bob)
	draw_circle(bob, 22, Color(col, 0.07))
	draw_circle(bob, 15, Color(col, 0.12))
	for i in 8:
		for bit in [1, 2, 4]:
			var j = i ^ bit
			if i < j:
				draw_line(pts[i], pts[j], Color(col, 0.9), 2.0)
