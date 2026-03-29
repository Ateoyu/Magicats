extends ColorRect

signal selected(upgrade: Upgrade)

@onready var upgrade_icon: ColorRect = $UpgradeIcon
@onready var upgrade_name: Label = $UpgradeName
@onready var upgrade_description: Label = $UpgradeDescription

var upgrade_data: Upgrade

func setup(upgrade: Upgrade) -> void:
	upgrade_data = upgrade
	#upgrade_icon.texture = upgrade.upgrade_icon
	upgrade_name.text = upgrade.upgrade_name
	upgrade_description.text = upgrade.upgrade_description

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit(upgrade_data)
