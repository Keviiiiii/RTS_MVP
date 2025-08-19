extends Area2D

@export var max_health: int = 100
var current_health: int

signal died

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	current_health -= amount
	print("%s took %d damage, health: %d" % [name, amount, current_health])
	if current_health <= 0:
		die()

func die() -> void:
	emit_signal("died")
	queue_free()
