extends ProgressBar

@export var player: Player

func _ready() -> void:
	if player:
		player.healthChanged.connect(updateHealth)
		updateHealth()

func updateHealth():
	value = player.currentHealth * 100 / player.maxHealth
