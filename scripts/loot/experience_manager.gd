extends Node

signal update_experience_bar
signal player_levelled_up
signal selected_upgrade(upgrade: Upgrade)

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0

var level_up_panel: TextureRect = null
var upgrade_options: VBoxContainer = null
var player: Player = null

var available_upgrades: Array[Upgrade] = []
var current_upgrade_options: Array[Upgrade] = []

func add_experience(amount: int) -> void:
	var experience_required: int = calculate_experience_cap()
	
	collected_experience += amount
	if experience + collected_experience >= experience_required:
		collected_experience -= experience_required - experience
		experience_level += 1
		level_up()
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

func set_level_up_panel(p: TextureRect) -> void: 
	self.level_up_panel = p

func set_upgrade_options(o: VBoxContainer) -> void:
	self.upgrade_options = o

func set_player(p: Player) -> void:
	self.player = p

func level_up() -> void:
	update_experience_bar.emit()
	get_tree().paused = true
	player_levelled_up.emit()

func show_upgrade_choices() -> void:
	current_upgrade_options.clear()
	
	var possible_upgrades = get_possible_upgrades()
	
	possible_upgrades.shuffle()
	for i in range(min(3, possible_upgrades.size())):
		current_upgrade_options.append(possible_upgrades[i])
	
	populate_upgrade_options()

func populate_upgrade_options():
	for child in upgrade_options.get_children():
		child.queue_free()
	
	var scene_path = preload("res://scenes/menu/upgradeOption.tscn")
	for upgrade_option in current_upgrade_options:
		var upgrade_option_instance = scene_path.instantiate()
		upgrade_options.add_child(upgrade_option_instance)
		
		upgrade_option_instance.setup(upgrade_option)
		
		upgrade_option_instance.selected.connect(_on_selected_upgrade)

func _on_selected_upgrade(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)
	get_tree().paused = false

func apply_upgrade(upgrade: Upgrade) -> void:
	match upgrade.upgrade_type:
		"heal":
			player.heal(upgrade.upgrade_value)
		"max_health":
			player.max_health += upgrade.upgrade_value
		"spell_upgrade":
			player.spell_manager.upgrade_spell(upgrade.upgrade_value)
		"speed":
			player.movement_speed += upgrade.upgrade_value
	selected_upgrade.emit(upgrade)

func get_possible_upgrades() -> Array[Upgrade]:
	var upgrades: Array[Upgrade] = []
	
	var heal_upgrade = Upgrade.new()
	heal_upgrade.upgrade_name = "Heal"
	heal_upgrade.upgrade_description = "Restore 50 HP"
	heal_upgrade.upgrade_type = "heal"
	heal_upgrade.upgrade_value = 50
	upgrades.append(heal_upgrade)
	
	var hp_upgrade = Upgrade.new()
	hp_upgrade.upgrade_name = "Vitality"
	hp_upgrade.upgrade_description = "Increase max HP by 20"
	hp_upgrade.upgrade_type = "max_health"
	hp_upgrade.upgrade_value = 20
	upgrades.append(hp_upgrade)
	
	var speed_upgrade = Upgrade.new()
	speed_upgrade.upgrade_name = "Haste"
	speed_upgrade.upgrade_description = "Increase movement speed by 50"
	speed_upgrade.upgrade_type = "speed"
	speed_upgrade.upgrade_value = 50
	upgrades.append(speed_upgrade)
	
	var available_spells = player.spell_manager.get_upgradable_spells()
	
	for spell in available_spells:
		var spell_upgrade = Upgrade.new()
		spell_upgrade.upgrade_name = spell.name
		spell_upgrade.upgrade_type = "spell_upgrade"
		spell_upgrade.upgrade_value = spell
			
		if spell.level == 0:
			spell_upgrade.upgrade_description = "Unlock " + spell.name
		else:
			spell_upgrade.upgrade_description = "Level up "  + spell.name + " to Level " + str(spell.level + 1)
		
		upgrades.append(spell_upgrade)
	
	return upgrades
