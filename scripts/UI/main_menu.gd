extends Node2D

var button_type = null
var waiting_for_confirmation: bool = false
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

@onready var hover_sound: AudioStreamPlayer = $PanelContainer/ButtonManager/Hover

func _ready() -> void:
	var saved_display_settings = GameManager.load_display_settings()
	get_window().size = saved_display_settings["resolution"]
	get_window().mode = saved_display_settings["display_mode"]
	
	var saved_sound_settings = GameManager.load_sound_settings()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(saved_sound_settings["master_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(saved_sound_settings["sfx_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(saved_sound_settings["music_volume"]))
	
	if get_window().mode == Window.MODE_WINDOWED:
		var screen_id = get_window().current_screen
		var screen_rect = DisplayServer.screen_get_usable_rect(screen_id)
		var window_size = get_window().get_size_with_decorations()
		get_window().position = screen_rect.position + (screen_rect.size - window_size) / 2

func _on_continue_pressed() -> void:
	if GameManager.has_save_file():
		button_type = "continue"
		$Fade_transition.show()
		$Fade_transition/Fade_timer.start()
		$Fade_transition/AnimationPlayer.play("fade_in")
	else:
		_on_new_game_pressed()

func _on_new_game_pressed() -> void:
	if GameManager.has_save_file():
		confirmation_dialog.dialog_text = "A save file already exists. Start a new game? All previous progress will be lost."
		confirmation_dialog.show()
		waiting_for_confirmation = true
	else:
		start_new_game()

func start_new_game() -> void:
	GameManager.delete_save_file()
	GameManager.new_game()
	button_type = "new_game"
	
	$Fade_transition.show()
	$Fade_transition/Fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	if button_type == "new_game":
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif button_type == "continue":
		GameManager.load_game()
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_confirmation_dialog_confirmed() -> void:
	waiting_for_confirmation = false
	start_new_game()

func _on_confirmation_dialog_canceled() -> void:
	waiting_for_confirmation = false

func _on_button_mouse_entered() -> void:
	hover_sound.play()
