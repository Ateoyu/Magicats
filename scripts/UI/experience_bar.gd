extends ProgressBar

@export var player: Player
@export var level_label: Label

func _ready() -> void:
	ExperienceManager.update_experience_bar.connect(_update_experience_bar)
	_update_experience_bar()

func _update_experience_bar() -> void:
	value = ExperienceManager.experience
	max_value = ExperienceManager.calculate_experience_cap()
	
	if level_label:
		level_label.text = str("Level: ", ExperienceManager.experience_level)
