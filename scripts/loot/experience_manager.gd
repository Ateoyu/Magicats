extends Node

signal update_experience_bar

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0

var level_up_panel: Panel = null
var upgrade_options: VBoxContainer = null

func _ready():
	if level_up_panel == null:
		print("panel still fucking null")
	else:
		print("we happy now")

func add_experience(amount: int) -> void:
	var experience_required: int = calculate_experience_cap()
	
	collected_experience += amount
	if experience + collected_experience >= experience_required:
		collected_experience -= experience_required - experience
		experience_level += 1
		update_experience_bar.emit()
		experience = 0
		experience_required = calculate_experience_cap()
		add_experience(0)
	else:
		experience += collected_experience
		collected_experience = 0
	update_experience_bar.emit()
	
func calculate_experience_cap() -> int:
	var experience_cap: int = experience_level
	
	if experience_level < 20:
		experience_cap = experience_level * 5
	elif experience_level < 40:
		experience_cap = 95 * (experience_level - 19) * 8
	else:
		experience_cap = 255 + (experience_level - 39) * 12
	return experience_cap
