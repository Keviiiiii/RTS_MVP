extends CombatBuilding

@export var game_over_scene: PackedScene

func _ready() -> void:
	max_health = 200
	attack_damage = 0
	attack_speed = 0
	attack_range = 0
	log_attacks = false
	super()

func _process(delta: float) -> void:
	pass

func die() -> void:
	queue_free()
	game_over()

func game_over() -> void:
	get_tree().paused = true  # Freeze the game
	if game_over_scene:
		var menu_instance = game_over_scene.instantiate()
		menu_instance.setup(false)
		get_tree().current_scene.add_child(menu_instance)
		menu_instance.show()
	else:
		print("Game Over! (No menu assigned)")
