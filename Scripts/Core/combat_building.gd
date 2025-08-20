extends Area2D
class_name CombatBuilding

@export var max_health: int = 100
@export var attack_damage: int = 10
@export var attack_speed: float = 1.0
@export var attack_range: float = 100
@export var log_attacks: bool = false
@export var size_in_cells: Vector2i = Vector2i(1,1)
@export var grid_size: int = 16

var current_health: int
var attack_cooldown: float = 0.0
var target: Node2D

signal died

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if target and is_instance_valid(target):
		if global_position.distance_to(target.global_position) <= attack_range:
			if attack_cooldown <= 0:
				attack(target)
				attack_cooldown = attack_speed
			else:
				target = null
		else:
			find_target("enemies")

func take_damage(amount: int) -> void:
	current_health -= amount
	print("%s took %d damage, health: %d" % [name, amount, current_health])
	if current_health <= 0:
		die()

func attack(target_entity: Node) -> void:
	if target_entity.has_method("take_damage"):
		target.take_damage(attack_damage)
		if log_attacks:
			print("%s attacked %s for %d damage" % [name, target_entity.name, attack_damage])

func find_target(group_name: String) -> void:
	var candidates = get_tree().get_nodes_in_group(group_name)
	if candidates.size() > 0:
		target = candidates[0]

func die() -> void:
	emit_signal("died")
	queue_free()


func get_occupied_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var snapped_x = floor(global_position.x / grid_size) * grid_size
	var snappex_y = floor(global_position.y / grid_size) * grid_size
	var top_left_world := Vector2(snapped_x, snappex_y)
	
	var top_left_cell := Vector2i(
		int(top_left_world.x / grid_size),
		int(top_left_world.y / grid_size)
	)
	
	for x in range(size_in_cells.x):
		for y in range(size_in_cells.y):
			cells.append(top_left_cell + Vector2i(x, y))
	
	return cells
