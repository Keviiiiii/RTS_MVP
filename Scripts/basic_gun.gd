extends Weapon


func _ready() -> void:
	super._ready()
	fire_rate = 1
	range = 250
	spread = 10
	projectile_damage = 15
	projectile_speed = 100
