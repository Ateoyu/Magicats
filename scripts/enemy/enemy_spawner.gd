extends Node2D

signal player_won

@export var spawns: Array[Spawn_info] = []
@export var player: Player
@onready var loot_base = get_node("%Loot")
var time = 0

@onready var time_left: Label = %TimeLeft


func _on_timer_timeout() -> void:
	time += 1
	
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	time_left.text = "%02d:%02d" % [minutes, seconds]
	
	if time >= 620:
		player_won.emit()
		return
	
	var enemy_spawns: Array[Spawn_info] = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy: Resource = i.enemy
				var counter: int = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					enemy_spawn.player = player
					enemy_spawn.loot_base = loot_base
					add_child(enemy_spawn)
					counter += 1

func get_random_position():
	var vpr: Vector2 = (get_viewport_rect().size / 0.4) * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn: float = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn: float = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)

# Helper funcs for respawning enemies if we leave the game.
# to maintain the thythm of the spawns, we need to save the spawn_delay_counter
func get_spawn_delays() -> Array:
	var delays = []
	for spawn in spawns:
		delays.append({
			"spawn_delay_counter": spawn.spawn_delay_counter
			})
	return delays

func set_spawn_delays(delays: Array) -> void:
	for i in range(min(spawns.size(), delays.size())):
		if delays[i].has("spawn_delay_counter"):
			spawns[i].spawn_delay_counter = delays[i].spawn_delay_counter

func set_time(value: float) -> void:
	time = value
