extends Node2D
class_name GridOverlay

@export var grid_size: int = 16

@export var grid_color: Color = Color(1,1,1,.2)
var ghost_building: Node = null
var is_valid: bool = true


func _draw() -> void:
	var viewport_size = get_viewport_rect().size
	for x in range(0, int(viewport_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), grid_color)
	for y in range(0, int(viewport_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), grid_color)


func set_ghost(building: Node2D, valid: bool = true) -> void:
	ghost_building = building
	is_valid = valid
	queue_redraw()

func clear_ghost() -> void:
	ghost_building = null
	queue_redraw()

func set_active(active: bool) -> void:
	visible = active
	queue_redraw()
