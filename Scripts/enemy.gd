extends CombatCharacter


func _ready() -> void:
	max_health = 50
	attack_damage = 5
	attack_speed = 4
	attack_range = 10
	move_speed = 40
	log_attacks = true
	super()
	find_target("buildings")

func move_towards_target(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()
