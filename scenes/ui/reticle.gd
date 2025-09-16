extends Node2D

func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	set_process(true)

func _draw():
	var size = 5
	var color = Color(0, 1, 0)

	draw_line(Vector2(-size, 0), Vector2(size, 0), color, 2)
	draw_line(Vector2(0, -size), Vector2(0, size), color, 2)
