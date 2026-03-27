extends Node2D

## save progress on game here (if quit to menu and resumed)

func _ready() -> void:
	get_window().mode = Window.MODE_WINDOWED
	get_window().borderless = false
