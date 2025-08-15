extends Node

var game_over_menu_scene := preload("res://Scenes/UI/game_over_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu() -> void:
	for child in get_tree().root.get_children():
		if child.name == "GameOverMenu":
			child.queue_free()
			get_tree().paused= false
			return

	var menu = game_over_menu_scene.instantiate()
	get_tree().root.add_child(menu)
	menu.setup(true)
	menu.visible = true

func on_command_center_destroyed() -> void:
	print("cc destroyed - game over")
	show_game_over_menu()

func show_game_over_menu() -> void:
	var menu = game_over_menu_scene.instantiate()
	get_tree().root.add_child(menu)
	menu.setup(false)
	menu.visible = true
