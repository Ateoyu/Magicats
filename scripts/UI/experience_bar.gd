extends ProgressBar

@export var player: Player
@export var level_label: Label

func _ready() -> void:
	if player:
		player.update_experience_bar.connect(_update_experience_bar)
		_update_experience_bar()

func _update_experience_bar() -> void:
	if player:
		value = player.experience
		max_value = player.calculate_experience_cap()
		
		if level_label:
			level_label.text = str("Level: ", player.experience_level)
