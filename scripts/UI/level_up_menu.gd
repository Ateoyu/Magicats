extends Control

@onready var level_up_sound: AudioStreamPlayer = $LevelUp

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	ExperienceManager.player_levelled_up.connect(_on_player_levelled_up)
	ExperienceManager.selected_upgrade.connect(_on_selected_upgrade)
	
func _on_player_levelled_up():
	level_up_sound.play()
	ExperienceManager.show_upgrade_choices()
	show()

func _on_selected_upgrade(upgrade: Upgrade):
	hide()
