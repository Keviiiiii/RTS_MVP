extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate := 2.0
@export var spawn_position: Vector2

var spawn_timer := 0.0

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_position
		get_tree().current_scene.add_child(enemy)
		spawn_timer = spawn_rate
