extends CombatBuilding

@export var weapon_scene: PackedScene = preload("res://Scenes/Buildings/Weapons/basic_gun.tscn")
var weapon: Node2D = null

@onready var weapon_mount: Node2D = $GunMount

func _ready() -> void:
	if weapon_scene:
		weapon = weapon_scene.instantiate()
		weapon_mount.add_child(weapon)
		weapon.turret_base = self

	max_health = 200
