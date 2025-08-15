extends Node2D

@export var bullet_scene: PackedScene

@export var range: float = 100.0
@export var fire_rate := .5
@export var rotation_speed = 5.0

@onready var timer = $fire_timer

func _ready() -> void:
	print("gun ready")
	timer.wait_time = fire_rate
	timer.timeout.connect(_on_FireTimer_timeout)

func _process(delta: float) -> void:
	var target = find_target()
	if target:
		look_at(target.global_position)

func _on_FireTimer_timeout() -> void:
	var target = find_target()
	if target:
		_shoot_at_target(target)

func find_target() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest: Node2D = null
	var closest_dist := range
	
	for enemy in enemies:
		if not enemy is Node2D:
			continue
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest = enemy
			closest_dist = dist
	
	return closest

func _shoot_at_target(target: Node2D) -> void:
	print("shooting")
	
	var bullet = bullet_scene.instantiate()
	
	var direction = (target.global_position - global_position).normalized()
	var offset_distance := 16 
	
	bullet.global_position = global_position + direction * offset_distance
	bullet.direction = direction
	bullet.velocity = direction
	
	get_tree().current_scene.add_child(bullet)
	print(bullet.position)
