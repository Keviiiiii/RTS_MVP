extends CharacterBody2D
class_name CombatCharacter

@export var max_health: int = 100
var current_health: int

@export var attack_damage: int = 20
@export var attack_speed: float = 1
@export var attack_range: float = 50
@export var move_speed: float = 100
@export var log_attacks: bool = false

var attack_cooldown = 0
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
		else:
			move_towards_target(delta)
	else:
		find_target("buildings")

func die() -> void:
	emit_signal("died")
	queue_free()

func take_damage(amount: int) -> void:
	current_health -= amount
	print("%s took %d damage, health: %d" % [name, amount, current_health])
	if current_health <= 0:
		die()

func find_target(group_name: String) -> void:
	var candidates = get_tree().get_nodes_in_group(group_name)
	if candidates.size() > 0:
		target = candidates[0]
	
func attack(target_entity: Node) -> void:
	if target_entity.has_method("take_damage"):
		target_entity.take_damage(attack_damage)
		if log_attacks:
			print("%s attacked %s for %d damage" % [name, target_entity.name, attack_damage])

func move_towards_target(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * 100
	move_and_slide()
