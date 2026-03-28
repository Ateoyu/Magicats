extends Node

const SAVE_PATH: String = "user://savegame.dat"
const SETTINGS_PATH: String = "user://settings.cfg"

var player: Player = null
var enemy_spawner: Node2D = null

func save_display_settings(resolution: Vector2i, display_mode: int) -> void:
	var config = ConfigFile.new()
	
	config.load(SETTINGS_PATH)
	
	config.set_value("display", "resolution_x", resolution.x)
	config.set_value("display", "resolution_y", resolution.y)
	config.set_value("display", "display_mode", display_mode)
	
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

func set_player(p: Player) -> void:
	player = p

func set_enemy_spawner(e: Node2D) -> void:
	enemy_spawner = e

func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func new_game() -> void:
	if player:
		player.current_health = player.max_health
		player.experience = 0
		player.experience_level = 1
		player.collected_experience = 0
		player.position = Vector2(0, 0) 
		player.health_changed.emit()
		player.update_experience_bar.emit()

	if enemy_spawner:
		enemy_spawner.time = 0
		for spawn in enemy_spawner.spawns:
			spawn.spawn_delay_counter = 0
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()

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
			"experience": player.experience,
			"experience_level": player.experience_level,
			"collected_experience": player.collected_experience,
			"position": {"x": player.position.x, "y": player.position.y},
			#"spells":
		},
		"enemy_spawner": get_enemy_spawner_data(),
		"enemies": get_alive_enemies_data()
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
			
			if save_data.has("enemy_spawner"):
				load_spawner_data(save_data["enemy_spawner"])
			
			if save_data.has("enemies"):
				load_enemies_data(save_data["enemies"])
			
			return true
	return false

func load_player_data(player_data: Dictionary) -> void:
	if player == null:
		return
	player.current_health = player_data["current_health"]
	player.max_health = player_data["max_health"]
	player.experience = player_data["experience"]
	player.experience_level = player_data["experience_level"]
	player.collected_experience = player_data["collected_experience"]
	player.position = Vector2(player_data["position"]["x"], player_data["position"]["y"])
	
	player.health_changed.emit()
	player.update_experience_bar.emit()
	
func load_spawner_data(spawner_data: Dictionary) -> void:
	if enemy_spawner == null:
		return
	
	if spawner_data.has("time"):
		enemy_spawner.set_time(spawner_data["time"])
	
	if spawner_data.has("spawn_delays"):
		enemy_spawner.set_spawn_delays(spawner_data["spawn_delays"])

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
			new_enemy.loot_base = enemy_spawner.get_node("%Loot") # not sure if this needs to exist?
			enemy_spawner.add_child(new_enemy)
