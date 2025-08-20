extends CombatBuilding


func _ready() -> void:
	max_health = 200
	attack_damage = 0
	attack_speed = 0
	attack_range = 0
	log_attacks = false
	super()

func _process(delta: float) -> void:
	pass
