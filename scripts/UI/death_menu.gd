extends Control

@export var player: Player

@onready var hover_sound: AudioStreamPlayer = $LevelUpPanel/ButtonManager/Hover
@onready var death_sound: AudioStreamPlayer = $DeathSound

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	player.player_died.connect(_on_player_died)

func _on_player_died():
	show()
	get_tree().paused = true
	death_sound.play()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	hide()
	GameManager.delete_save_file()
	GameManager.new_game()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.delete_save_file()
	hide()
	get_tree().change_scene_to_file("res://scenes/menu/mainMenu.tscn")

func _on_button_mouse_entered() -> void:
	hover_sound.play()
