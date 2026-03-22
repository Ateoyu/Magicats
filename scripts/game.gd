extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready() -> void:
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_out")
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):

		if get_tree().paused:
			pause_menu.resume()
		else:
			pause_menu.pause()
