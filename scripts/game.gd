extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var player: Player = %Player

func _ready() -> void:
	GameManager.set_player(player)
	
	if GameManager.has_save_file():
		GameManager.load_game()
		
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
