extends Node2D

var layout = []
var tile = 40
var offset = Vector2.ZERO
var t = 0.0

func _ready():
	position = offset
	queue_redraw()

func _process(delta):
	t += delta
	modulate.a = 0.85 + 0.15 * sin(t * 2.0)

func _is_wall(x, y):
	if y < 0 or y >= layout.size() or x < 0 or x >= layout[y].length():
		return false
	return layout[y][x] == "#"

func _draw():
	var cols = layout[0].length()
	for y in layout.size():
		for x in cols:
			var p = Vector2(x, y) * tile
			if layout[y][x] == "#":
				var c = Color("19f2ff").lerp(Color("b040ff"), float(x) / cols)
				if not _is_wall(x, y - 1):
					_edge(p, p + Vector2(tile, 0), c)
				if not _is_wall(x, y + 1):
					_edge(p + Vector2(0, tile), p + Vector2(tile, tile), c)
				if not _is_wall(x - 1, y):
					_edge(p, p + Vector2(0, tile), c)
				if not _is_wall(x + 1, y):
					_edge(p + Vector2(tile, 0), p + Vector2(tile, tile), c)
			else:
				draw_circle(p + Vector2(tile, tile) / 2, 1.5, Color(0.3, 0.6, 1.0, 0.2))

func _edge(a, b, c):
	draw_line(a, b, Color(c, 0.07), 14.0)
	draw_line(a, b, Color(c, 0.18), 8.0)
	draw_line(a, b, Color(c, 0.45), 4.0)
	draw_line(a, b, c.lerp(Color.WHITE, 0.6), 1.5)
