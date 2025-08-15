extends Area2D

@export var footprint := Vector2i(1,1)
@export var health := 500

func _ready() -> void:
	set_meta("footprint", footprint)

func take_damage(amount: int) -> void:
	health -= amount
	print(health)
	if health <= 0:
		queue_free()
