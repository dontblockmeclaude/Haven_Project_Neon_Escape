extends CharacterBody2D

signal hit_player(hazard)

const SPEED = 120.0
var t = randf() * 10.0

func _ready():
	$HitBox.body_entered.connect(_on_hitbox_body_entered)
	var dirs = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	velocity = dirs.pick_random() * SPEED
	var m = CanvasItemMaterial.new()
	m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = m

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if absf(velocity.x) > absf(velocity.y):
			velocity = Vector2(signf(velocity.x), 0) * SPEED
		else:
			velocity = Vector2(0, signf(velocity.y)) * SPEED

func _process(delta):
	t += delta
	queue_redraw()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		hit_player.emit(self)

func _draw():
	var c = Color("ff2ec4")
	var pulse = 1.0 + 0.15 * sin(t * 8.0)
	draw_circle(Vector2.ZERO, 22 * pulse, Color(c, 0.07))
	draw_circle(Vector2.ZERO, 16 * pulse, Color(c, 0.16))
	draw_circle(Vector2.ZERO, 10, Color(c, 0.7))
	draw_circle(Vector2.ZERO, 5, Color(1, 0.85, 1))
