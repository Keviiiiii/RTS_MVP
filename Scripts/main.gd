extends Node2D

const GRID_SIZE = 16
const GUN_TYPES = [
	preload("res://Scenes/Buildings/Weapons/basic_gun.tscn"),
	preload("res://Scenes/Buildings/Weapons/sniper_turret.tscn")
]

#list of building types
var building_types = [
	{
		name = "Wall",
		build_scene = preload("res://Scenes/Buildings/wall.tscn"),
		preview_scene = preload("res://Scenes/Previews/wall_preview.tscn"),
		size = Vector2(1,1)
	},
	{
		name = "Turret",
		build_scene = preload("res://Scenes/Buildings/turret_base.tscn"),
		preview_scene = preload("res://Scenes/Previews/turret_base_preview.tscn"),
		size = Vector2(2,2)
	}
]

var current_building_index = 0
var preview: Node2D
var occupied_cells := {}

func _ready() -> void:
	print("ready")
	add_to_group("game")
	load_preview()

func _process(delta: float) -> void:
	update_preview_position()
	
	var grid_pos = get_grid_position(get_viewport().get_mouse_position())
	preview.position = to_world_position(grid_pos)
	
	var can_place = true
	for x in range(building_types[current_building_index].size.x):
		for y in range(building_types[current_building_index].size.y):
			var cell = grid_pos + Vector2i(x,y)
			if occupied_cells.has(cell):
				can_place = false
	preview.modulate = Color(0, 1, 0, 0.5) if can_place else Color(1, 0, 0, 0.5)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			try_place_building()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if not try_switch_gun_on_hover(1):
				change_building_type(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if not try_switch_gun_on_hover(-1):
				change_building_type(-1)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			remove_building_at_cursor()

func try_place_building() -> void:
	var grid_pos = get_grid_position(preview.position)

	# Start with the default size from building_types
	var size = building_types[current_building_index].size

	# Check if the cells are free before placing
	for x in range(size.x):
		for y in range(size.y):
			var cell = grid_pos + Vector2i(x, y)
			if occupied_cells.has(cell):
				print("Can't place at: ", cell)
				return

	# Instantiate and position the building
	var new_building = building_types[current_building_index].build_scene.instantiate()
	new_building.position = to_world_position(grid_pos)
	add_child(new_building)

	# ✅ Safely check for a custom 'footprint' in the script
	if new_building.has_meta("footprint"):
		size = new_building.footprint
	else:
		size = Vector2i(1, 1)

	# Mark those grid cells as occupied
	for x in range(size.x):
		for y in range(size.y):
			var cell = grid_pos + Vector2i(x, y)
			occupied_cells[cell] = true

func try_switch_gun_on_hover(direction: int) -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = get_world_2d().direct_space_state.intersect_point(query)
	
	for result in results:
		var turret = result.collider
		if turret and turret.has_method("set_gun_index"):
			turret.set_gun_index(direction)
			return(true)
	
	return(false)

func change_building_type(direction: int) -> void:
	current_building_index = (current_building_index + direction) % building_types.size()
	if current_building_index < 0:
		current_building_index = building_types.size() - 1
	load_preview()

func load_preview() -> void:
	if preview:
		preview.queue_free()
	preview = building_types[current_building_index].preview_scene.instantiate()
	add_child(preview)
	print("switched to: ", building_types[current_building_index].name)

func get_grid_position(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / GRID_SIZE),
		floor(world_pos.y / GRID_SIZE)
	)

func to_world_position(grid_pos: Vector2i) -> Vector2:
	return grid_pos * GRID_SIZE

func remove_building_at_cursor() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = get_world_2d().direct_space_state.intersect_point(query)
	
	for hit in results:
		var building = hit.collider
		if building and building != preview:
			print("removing: ", building.name)
			
			var grid_pos = get_grid_position(building.position)
			
			var size = Vector2i(1,1)
			if building.has_meta("footprint"):
				size = building.get("footprint")
				
			for x in range(size.x):
				for y in range(size.y):
					var cell = grid_pos + Vector2i(x, y)
					occupied_cells.erase(cell)
					
			building.queue_free()
			break

func update_preview_position() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var grid_pos = get_grid_position(mouse_pos)
	preview.position = to_world_position(grid_pos)

func on_command_center_destroyed() -> void:
	show_game_over_menu()

func show_game_over_menu() -> void:
	var game_over_menu = preload("res://Scenes/UI/game_over_menu.tscn")
	get_tree().root.add_child(game_over_menu)
