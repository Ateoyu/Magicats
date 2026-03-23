extends ProgressBar

@export var player: Player
@export var level_label: Label

func _ready() -> void:
	if player:
		player.experience_changed.connect(_on_experience_changed)
		player.level_up.connect(_on_level_up)
		_update_display()

func _on_experience_changed() -> void:
	_update_display()

func _on_level_up(new_level: int) -> void:
	_update_display()

func _update_display() -> void:
	if player:
		value = player.experience
		max_value = player.calculate_experience_cap()
		
		if level_label:
			level_label.text = str("Level: ", player.experience_level)
