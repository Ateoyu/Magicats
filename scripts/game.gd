class_name GameManager
extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready() -> void:
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
