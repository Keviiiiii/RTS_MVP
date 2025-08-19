extends Node
class_name GridManager

var grid_size: int = 16
var occupied := {} #dictionary: key = vector2i cell, value = bool

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(floor(world_pos.x /grid_size)),
		int(floor(world_pos.y /grid_size))
	)

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x * grid_size, grid_pos.y * grid_size)

func snap_to_grid(world_pos: Vector2) -> Vector2:
	return Vector2(
		floor(world_pos.x / grid_size) * grid_size,
		floor(world_pos.y / grid_size) * grid_size
	)

func is_cell_free(cells: Vector2i) -> bool:
	for c in cells:
		if occupied.has(c) and occupied[c] == true:
			return false
	return true

func is_cell_occupied(cell: Vector2i) -> bool:
	return occupied.get(cell, false)

func occupy_cell(cells: Array[Vector2i]) -> void:
	for c in cells:
		occupied[c] = true

func free_cell(cells: Array[Vector2i]) -> void:
	for c in cells:
		occupied[cells] = false
