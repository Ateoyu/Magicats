extends Control

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	#var viewport_size = get_viewport().get_visible_rect().size # center on the screen if needed
	#position = (viewport_size - size) / 2
	
func resume():
	hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _on_resume_pressed() -> void:
	resume()

func _on_main_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
