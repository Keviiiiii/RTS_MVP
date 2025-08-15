extends Area2D

@export var gun_scene: PackedScene
@export var footprint := Vector2i(2,2)
@export var health := 100

@onready var gun_mount = $GunMount

func _ready() -> void:
	set_meta("footprint", footprint)
	if gun_scene:
		var gun = gun_scene.instantiate()
		gun.position = gun_mount.position
		add_child(gun)

func take_damage(amount: int) -> void:
	health -= amount
	print(health)
	if health <= 0:
		queue_free()
#func get_footprint() -> Vector2i:
	#return footprint
