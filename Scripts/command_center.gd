extends Area2D

@export var max_health := 200
var current_health:= 500

func _ready() -> void:
	current_health - max_health
	add_to_group("buildings")
	add_to_group("command_center")

func take_damage(amount: int) -> void:
	current_health -= amount
	print(current_health)
	if current_health <= 0:
		_on_destroyed()

func _on_destroyed() -> void:
	GameManager.on_command_center_destroyed()
	queue_free()
