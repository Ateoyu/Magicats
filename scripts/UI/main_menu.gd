extends Node2D

var button_type = null

func _ready() -> void:
	var saved_settings = GameManager.load_display_settings()
	get_window().size = saved_settings["resolution"]
	get_window().mode = saved_settings["display_mode"]
	
	if get_window().mode == Window.MODE_WINDOWED:
		var screen_id = get_window().current_screen
		var screen_rect = DisplayServer.screen_get_usable_rect(screen_id)
		var window_size = get_window().get_size_with_decorations()
		get_window().position = screen_rect.position + (screen_rect.size - window_size) / 2

func _on_start_pressed() -> void:
	button_type = "start"
	$Fade_transition.show()
	$Fade_transition/Fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://scenes/game.tscn")
