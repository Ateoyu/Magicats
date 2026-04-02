extends Control

@onready var enemy_spawner: Node2D = %EnemySpawner

@onready var hover_sound: AudioStreamPlayer = $WinPanel/ButtonManager/Hover

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	enemy_spawner.player_won.connect(_on_player_won)

func _on_player_won():
	show()
	get_tree().paused = true

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.delete_save_file()
	hide()
	get_tree().change_scene_to_file("res://scenes/menu/mainMenu.tscn")

func _on_button_mouse_entered() -> void:
	hover_sound.play()

func _on_new_game_pressed() -> void:
	GameManager.delete_save_file()
	GameManager.new_game()
	get_tree().paused = false
	hide()
	GameManager.load_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()
