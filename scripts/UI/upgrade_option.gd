extends TextureRect

signal selected(upgrade: Upgrade)

@onready var upgrade_icon: TextureRect = $HBoxContainer/UpgradeIcon
@onready var upgrade_name: Label = $HBoxContainer/VBoxContainer/UpgradeName
@onready var upgrade_description: Label = $HBoxContainer/VBoxContainer/UpgradeDescription

@onready var hover_sound: AudioStreamPlayer = $Hover

var upgrade_data: Upgrade

func setup(upgrade: Upgrade) -> void:
	upgrade_data = upgrade
	upgrade_icon.texture = upgrade.upgrade_icon
	upgrade_name.text = upgrade.upgrade_name
	upgrade_description.text = upgrade.upgrade_description

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit(upgrade_data)


func _on_mouse_entered() -> void:
	hover_sound.play()
