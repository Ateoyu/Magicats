extends Control

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()
	
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
	GameManager.save_game()
	get_tree().change_scene_to_file("res://scenes/menu/mainMenu.tscn")

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()
