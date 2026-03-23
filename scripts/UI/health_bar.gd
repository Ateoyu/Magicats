extends ProgressBar

@export var player: Player

func _ready() -> void:
	if player:
		player.health_changed.connect(updateHealth)
		updateHealth()

func updateHealth():
	value = player.current_health * 100 / player.max_health
