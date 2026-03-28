extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var player: Player = %Player
@onready var enemy_spawner: Node2D = %EnemySpawner

func _ready() -> void:
	GameManager.set_player(player)
	GameManager.set_enemy_spawner(enemy_spawner)
	
	if GameManager.has_save_file():
		GameManager.load_game()
		
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
