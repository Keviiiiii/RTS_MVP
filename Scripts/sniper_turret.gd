extends Weapon
class_name SniperTurret


func _ready() -> void:
	super._ready()
	fire_rate = 2
	range = 600
	spread = 5
	projectile_damage = 30
	projectile_speed = 300
