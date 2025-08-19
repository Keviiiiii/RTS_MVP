extends Projectile
class_name bullet

@export var override_damage: int = -1
@export var override_speed: float = -1
@export var override_lifetime: float = -1

func _ready() -> void:
	if override_damage > -1:
		damage = override_damage
	if override_speed > -1:
		speed = override_speed
	if override_lifetime > -1:
		lifetime = override_lifetime
