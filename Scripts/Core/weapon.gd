extends Node2D
class_name Weapon

@export var bullet_scene: PackedScene
@export var muzzle_offset: float = 16
@export var range: float = 100
@export var fire_rate: float = .5
@export var spread: float = 0
@export var projectile_speed: float = 100
@export var rotation_speed: float = 5
@export var projectile_lifetime: float = 1.5
@export var projectile_damage: int = 10


@onready var timer: Timer = $FireTimer

var current_target: Node2D = null
var turret_base: CombatBuilding = null


func _ready() -> void:
	timer.wait_time = fire_rate
	timer.start()
	timer.timeout.connect(_on_fire_timeout)

func _process(delta: float) -> void:
	if current_target and is_instance_valid(current_target):
		var desired_angle = (current_target.global_position - global_position).angle()
		rotation = lerp_angle(rotation, desired_angle, rotation_speed * delta)

func _on_fire_timeout() -> void:
	var target = find_target()
	if target != current_target:
		current_target = target
		timer.start()
		return
	if current_target:
		shoot(current_target)

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

func shoot(target: Node2D) -> void:
	print("basic gun shooting")
	if not bullet_scene or not target:
		return
	
	var dir = (target.global_position - global_position).normalized()
	
	var bullet = bullet_scene.instantiate() as Projectile
	bullet.global_position = global_position + dir * muzzle_offset
	get_tree().current_scene.add_child(bullet)
	
	bullet.fire(self, dir, projectile_speed, projectile_damage, projectile_lifetime)
