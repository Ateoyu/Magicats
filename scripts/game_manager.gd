extends Node

var save_path: String = "user://savegame.dat"

var player: Player = null
var enemy_spawner: Node2D = null

func _ready() -> void:
	get_window().mode = Window.MODE_WINDOWED
	get_window().borderless = false

func set_player(p: Player) -> void:
	player = p
	print("Player set in GameManager")

func has_save_file() -> bool:
	return FileAccess.file_exists(save_path)
	
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
		}
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
	else:
		print("Failed to save game")
		
	
func load_game() -> bool:
	if player == null:
		return false
	if not FileAccess.file_exists(save_path):
		return false
		
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var save_data = JSON.parse_string(content)
		
		if save_data:
			print("Loading save")
			load_player_data(save_data["player"])
			return true
		else:
			return false
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
