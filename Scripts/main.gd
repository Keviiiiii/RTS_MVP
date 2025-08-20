extends Node2D

const GRID_SIZE: int = 16
const BUILD_RADIUS: int = 250
const NO_BUILD_RADIUS: int = 500
const SPAWN_RADIUS: int = 750

var occupied_cells: Array= []
var selected_building_scene: PackedScene = null
var ghost_building: Node2D = null

@onready var command_center = $CommandCenter
@onready var starting_turret = $Turret
@onready var grid_manager: GridManager = $GridManager
@onready var grid_overlay: GridOverlay = $GridOverlay


func _ready() -> void:
	if command_center and command_center.has_method("get_occupied_cells"):
		grid_manager.occupy_cells(command_center.get_occupied_cells(), command_center)
	if starting_turret and starting_turret.has_method("get_occupied_cells"):
		grid_manager.occupy_cells(starting_turret.get_occupied_cells(), starting_turret)

func _process(delta: float) -> void:
	if ghost_building:
		var snapped_pos = grid_manager.snap_to_grid(get_global_mouse_position())
		ghost_building.global_position = snapped_pos
		update_ghost_color()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				select_building(preload("res://Scenes/Buildings/wall.tscn"))
			KEY_2:
				select_building(preload("res://Scenes/Buildings/turret_base.tscn"))
			KEY_0:
				select_building(null)
				
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			try_place_building()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			remove_building_under_mouse()

#--zone checks--
func is_in_build_zone(world_pos: Vector2) -> bool:
	return world_pos.distance_to(command_center.global_position) <= BUILD_RADIUS

func is_in_no_build_zone(world_pos: Vector2) -> bool:
	return world_pos.distance_to(command_center.global_position) <= NO_BUILD_RADIUS and not is_in_build_zone(world_pos)

func is_in_spawn_zone(world_pos: Vector2) -> bool:
	return world_pos.distance_to(command_center.global_position) >= SPAWN_RADIUS

#--building selector--
func select_building(scene: PackedScene):
	print("select building called")
	selected_building_scene = scene
	
	if ghost_building: 
		ghost_building.queue_free()
		ghost_building = null

	if scene != null:
		ghost_building = scene.instantiate()
		add_child(ghost_building)
		ghost_building.modulate = Color(1,1,1,0.5)
		ghost_building.z_index = 1000
		ghost_building.global_position = grid_manager.snap_to_grid(get_global_mouse_position())
		update_ghost_color()
		grid_overlay.set_active(true)
	else: 
		grid_overlay.set_active(false)

func update_ghost_color() -> void:
	if ghost_building == null:
		return
	if can_place_building_at(ghost_building):
		ghost_building.modulate = Color(0,1,0,.5)#red
	else:
		ghost_building.modulate = Color(1,0,0,.5) #green

#--building placement--
func try_place_building():
	if selected_building_scene == null:
		print("no building selected")
		return
	
	if ghost_building:
		ghost_building.global_position = grid_manager.snap_to_grid(get_global_mouse_position())
	
	#var snapped_pos = grid_manager.snap_to_grid(get_global_mouse_position())
	if not can_place_building_at(ghost_building):
		print("blocked: invalid placement")
		return
		
	var new_building = selected_building_scene.instantiate()
	add_child(new_building)
	new_building.global_position = ghost_building.global_position
	
	if new_building.has_method("get_occupied_cells"):
		grid_manager.occupy_cells(new_building.get_occupied_cells(), new_building)
	
	print("placed building at: ", new_building.get_occupied_cells())

func can_place_building_at(building: Node2D) -> bool:
	if not is_in_build_zone(building.global_position): return false
	if is_in_no_build_zone(building.global_position): return false
	
	if not building.has_method("get_occupied_cells"): return false
	
	var cells: Array[Vector2i] = building.get_occupied_cells()
	return grid_manager.are_cells_free(cells)

func remove_building_under_mouse():
	var mouse_pos = get_global_mouse_position()
	var grid_pos = grid_manager.world_to_grid(mouse_pos)
	
	if grid_manager.cell_to_building.has(grid_pos):
		var building = grid_manager.cell_to_building[grid_pos]
		
		if building and building.has_method("get_occupied_cells"):
			grid_manager.free_cells(building.get_occupied_cells())
			building.queue_free()
			print("Removed building at: ", grid_pos)
	else:
		print("no building at: ", grid_pos)

#enemy spawining
func spawn_enemy(enemy_scene: PackedScene):
	var spawn_pos = get_random_spawn_position()
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_pos

func get_random_spawn_position():
	var angle = randf() * TAU
	var distance = SPAWN_RADIUS + randf() * 50
	var pos = command_center.global_position + Vector2(cos(angle), sin(angle)) * distance
	return grid_manager.snap_to_grid(pos)



func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy(preload("res://Scenes/enemies/enemy.tscn"))
