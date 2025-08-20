extends Node
class_name GridManager

@export var grid_size: int = 16
var occupied : Dictionary = {} #dictionary: key = vector2i cell, value = bool
var cell_to_building: Dictionary = {}

#----Grid Helpers
func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(world_pos.x /grid_size),
		floori(world_pos.y /grid_size)
	)

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * grid_size, 
		grid_pos.y * grid_size
	)

func snap_to_grid(world_pos: Vector2) -> Vector2:
	return grid_to_world(world_to_grid(world_pos))

#----Cell Management----
func is_cell_free(cell: Vector2i) -> bool:
	return not occupied.get(cell, false)

func are_cells_free(cells: Array[Vector2i]) -> bool:
	for c in cells:
		if not is_cell_free(c):
			return false
	return true

func occupy_cells(cells: Array[Vector2i], building: Node) -> void:
	for cell in cells:
		occupied[cell] = true
		cell_to_building[cell] = building

func free_cells(cells: Array[Vector2i]) -> void:
	for cell in cells:
		occupied.erase(cell)
		cell_to_building.erase(cell)

func free_building(building: Node) -> void:
	if not building.has_method("get_occupied_cells"):
		return
	var cells = building.get_occupied_cells()
	free_cells(cells)
