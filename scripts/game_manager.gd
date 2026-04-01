extends Node

const SAVE_PATH: String = "user://savegame.dat"
const SETTINGS_PATH: String = "user://settings.cfg"

var experience_manager: ExperienceManager = null
var player: Player = null
var enemy_spawner: Node2D = null
var loot_base: Node2D = null

func save_display_settings(resolution: Vector2i, display_mode: int) -> void:
	var config = ConfigFile.new()
	
	config.load(SETTINGS_PATH)
	
	config.set_value("display", "resolution_x", resolution.x)
	config.set_value("display", "resolution_y", resolution.y)
	config.set_value("display", "display_mode", display_mode)
	
	config.save(SETTINGS_PATH)

func save_sound_settings(master_volume: float, sfx_volume: float, music_volume: float) -> void:
	var config = ConfigFile.new()
	
	config.load(SETTINGS_PATH)
	
	config.set_value("sound", "master_volume", master_volume)
	config.set_value("sound", "sfx_volume", sfx_volume)
	config.set_value("sound", "music_volume", music_volume)
	
	config.save(SETTINGS_PATH)

func load_display_settings() -> Dictionary:
	var config = ConfigFile.new()
	var settings = {
		"resolution": Vector2i(1920, 1080),
		"display_mode": Window.MODE_WINDOWED
	}
	
	if config.load(SETTINGS_PATH) == OK:
		var resolution_x = config.get_value("display", "resolution_x", 1920)
		var resolution_y = config.get_value("display", "resolution_y", 1080)
		settings["resolution"] = Vector2i(resolution_x, resolution_y)
		settings["display_mode"] = config.get_value("display", "display_mode", Window.MODE_WINDOWED)
	
	return settings

func load_sound_settings() -> Dictionary:
	var config = ConfigFile.new()
	var settings = {
		"master_volume": 1.0,
		"sfx_volume": 1.0,
		"music_volume": 1.0
	}
	
	if config.load(SETTINGS_PATH) == OK:
		settings["master_volume"] = config.get_value("sound", "master_volume", 1.0)
		settings["sfx_volume"] = config.get_value("sound", "sfx_volume", 1.0)
		settings["music_volume"] = config.get_value("sound", "music_volume", 1.0)
	
	return settings

func set_player(p: Player) -> void:
	player = p

func set_experience_manager(m: ExperienceManager) -> void:
	experience_manager = m

func set_enemy_spawner(e: Node2D) -> void:
	enemy_spawner = e

func set_loot_base(l: Node2D) -> void:
	loot_base = l

func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func new_game() -> void:
	if player:
		player.max_health = player.default_max_health
		player.movement_speed = player.default_movement_speed
		player.current_health = player.max_health
		player.pickup_range = player.default_pickup_range
		player.position = Vector2(0, 0)
		player.health_changed.emit()

		if player.spell_manager:
			player.spell_manager.reset()
		
	if experience_manager:
			experience_manager.reset()
	
	if enemy_spawner:
		enemy_spawner.time = 0
		for spawn in enemy_spawner.spawns:
			spawn.spawn_delay_counter = 0
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	
	var all_loot = get_tree().get_nodes_in_group("loot")
	for loot in all_loot:
		loot.queue_free()
	
	var spells = get_tree().get_nodes_in_group("spell")
	for spell in spells:
		spell.queue_free()

func delete_save_file() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

func save_game() -> void:
	if player == null:
		return
	
	var save_data = {
		"player": {
			"current_health": player.current_health,
			"max_health": player.max_health,
			"movement_speed": player.movement_speed,
			"pickup_range": player.pickup_range,
			"position": {"x": player.position.x, "y": player.position.y},
			"spells": get_spell_data()
		},
		"experience_manager": get_experience_manager_data(),
		"enemy_spawner": get_enemy_spawner_data(),
		"enemies": get_alive_enemies_data(),
		"loot": get_uncollected_loot_data()
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
	else:
		print("Failed to save game")

func load_game() -> bool:
	if player == null:
		return false
	if not FileAccess.file_exists(SAVE_PATH):
		return false
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var save_data = JSON.parse_string(content)
		
		if save_data:
			load_player_data(save_data["player"])
			
			if save_data.has("experience_manager"):
				load_experience_manager_data(save_data["experience_manager"])
			
			if save_data.has("enemy_spawner"):
				load_spawner_data(save_data["enemy_spawner"])
			
			if save_data.has("enemies"):
				load_enemies_data(save_data["enemies"])
				
			if save_data.has("loot"):
				load_loot_data(save_data["loot"])

			if save_data.has("spells"):
				player.spell_manager.reset()
				load_spell_data(save_data["spells"])
			
			experience_manager.update_experience_bar.emit()
			return true
	return false

func load_player_data(player_data: Dictionary) -> void:
	if player == null:
		return
	player.current_health = player_data["current_health"]
	player.max_health = player_data["max_health"]
	player.movement_speed = player_data["movement_speed"]
	player.pickup_range = player_data["pickup_range"]
	player.position = Vector2(player_data["position"]["x"], player_data["position"]["y"])

	player.health_changed.emit()
	experience_manager.update_experience_bar.emit()
	
func load_experience_manager_data(exp_manager_data: Dictionary) -> void:
	if experience_manager == null:
		return
	
	experience_manager.experience = exp_manager_data["experience"]
	experience_manager.experience_level = exp_manager_data["experience_level"]
	experience_manager.collected_experience  = exp_manager_data["collected_experience"]
	experience_manager.update_experience_bar.emit()

func load_spawner_data(spawner_data: Dictionary) -> void:
	if enemy_spawner == null:
		return
	
	if spawner_data.has("time"):
		enemy_spawner.set_time(spawner_data["time"])
	
	if spawner_data.has("spawn_delays"):
		enemy_spawner.set_spawn_delays(spawner_data["spawn_delays"])

func get_experience_manager_data() -> Dictionary:
	if experience_manager == null:
		return {}
	return {
		"experience": experience_manager.experience,
		"experience_level": experience_manager.experience_level,
		"collected_experience": experience_manager.collected_experience
	}

func get_enemy_spawner_data() -> Dictionary:
	if enemy_spawner == null:
		return {}
	
	return {
		"time": enemy_spawner.time,
		"spawn_delays": enemy_spawner.get_spawn_delays()
	}

func get_alive_enemies_data() -> Array:
	var enemies_data = []
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		if enemy is Enemy:
			var enemy_data = {
				"scene_path": enemy.scene_file_path,
				"position": {"x": enemy.position.x, "y": enemy.position.y},
				"current_health": enemy.current_health,
				"max_health": enemy.max_health,
			}
			enemies_data.append(enemy_data)
	
	return enemies_data

func load_enemies_data(enemies_data: Array) -> void:
	var existing_enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in existing_enemies:
		enemy.queue_free()
	
	for enemy_data in enemies_data:
		var enemy_scene = load(enemy_data["scene_path"])
		if enemy_scene:
			var new_enemy = enemy_scene.instantiate()
			new_enemy.position = Vector2(enemy_data["position"]["x"], enemy_data["position"]["y"])
			new_enemy.current_health = enemy_data["current_health"]
			new_enemy.max_health = enemy_data["max_health"]
			new_enemy.player = player
			new_enemy.loot_base = enemy_spawner.get_node("%Loot") 
			enemy_spawner.add_child(new_enemy)

func get_uncollected_loot_data() -> Array:
	var all_loot_data = []
	var all_loot = get_tree().get_nodes_in_group("loot")
	
	for loot_item in all_loot:
		if loot_item is ExperienceGem:
			var loot_item_data = {
				"scene_path": loot_item.scene_file_path,
				"position": {"x": loot_item.position.x, "y": loot_item.position.y},
				"pickup_value": loot_item.pickup_value,
				"pickup_type": "experience"
			}
			all_loot_data.append(loot_item_data)
		elif loot_item is HealthItem:
			var loot_item_data = {
				"scene_path": loot_item.scene_file_path,
				"position": {"x": loot_item.position.x, "y": loot_item.position.y},
				"pickup_value": loot_item.pickup_value,
				"pickup_type": "health"
			}
			all_loot_data.append(loot_item_data)
	
	return all_loot_data

func load_loot_data(all_loot_data: Array) -> void:
	var uncollected_loot = get_tree().get_nodes_in_group("loot")
	for loot_item in uncollected_loot:
		loot_item.queue_free()
	
	for loot_item_data in all_loot_data:
		var loot_scene = load(loot_item_data["scene_path"])
		if loot_scene:
			var new_loot = loot_scene.instantiate()
			new_loot.position = Vector2(loot_item_data["position"]["x"], loot_item_data["position"]["y"])
			new_loot.pickup_value = loot_item_data["pickup_value"]
			new_loot.pickup_type = loot_item_data["pickup_type"]
			loot_base.add_child(new_loot)

func get_spell_data() -> Array:
	var spell_data: Array = []
	for spell in player.spell_manager.equipped_spells:
		spell_data.append({"name": spell.name, "level": spell.level})
	return spell_data

func load_spell_data(spell_data_array: Array) -> void:
	if player == null or player.spell_manager == null:
		return
	player.spell_manager.equipped_spells.clear()
	for saved_spell in spell_data_array:
		for spell in player.spell_manager.all_available_spells:
			if spell.name == saved_spell["name"]:
				spell.level = int(saved_spell["level"])
				if spell.level > 0:
					spell.spell_manager = player.spell_manager
					spell.player = player
					spell.apply_level_stats()
					player.spell_manager.equipped_spells.append(spell)
