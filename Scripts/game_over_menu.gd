extends CanvasLayer

var is_pause_menu := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	#resume_button.visible = is_pause_mode
	if is_pause_menu:
		get_tree().paused = true

func setup(is_pause: bool) -> void:
	is_pause_menu = is_pause

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()
