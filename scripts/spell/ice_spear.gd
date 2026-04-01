class_name IceSpear
extends Spell

var velocity: int
var projectile_count: int
var projectile_hp: int
var ice_spear_projectile: PackedScene = preload("res://scenes/spell/iceSpear.tscn")

func _init(p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	super("Ice Spear", 1, p_spell_manager, p_player)
	apply_level_stats()

func apply_level_stats() -> void:
	match level:
		1:
			damage = 5
			cooldown = 0.75
			velocity = 250
			projectile_count = 1
			projectile_hp = 1
		2:
			damage = 7
			cooldown = 0.75
			velocity = 275
			projectile_count = 1
			projectile_hp = 2
		3:
			damage = 9
			cooldown = 0.65
			velocity = 300
			projectile_count = 2
			projectile_hp = 2
		4:
			damage = 12
			cooldown = 0.55
			velocity = 325
			projectile_count = 3
			projectile_hp = 3
		5:
			damage = 15
			cooldown = 0.45
			velocity = 375
			projectile_count = 5
			projectile_hp = 4

func get_upgrade_description() -> String:
	match level + 1:
		2: return "Ice Spear pierces an extra enemy"
		3: return "Ice Spear fires 2 projectiles"
		4: return "Ice Spear fires 3 piercing projectiles"
		5: return "Ice Spear unleashes a barrage of 5 spears"
		_: return ""

func cast() -> void:
	for i in projectile_count:
		var target_position: Vector2 = get_random_target()

		var projectile: IceSpearProjectile = ice_spear_projectile.instantiate()
		projectile.global_position = player.global_position
		projectile.initialize(target_position, damage, velocity, projectile_hp)

		spell_manager.add_child(projectile)

func get_random_target() -> Vector2:
	if player.enemy_close.size() > 0:
		return player.enemy_close.pick_random().global_position
	else:
		return player.global_position + Vector2.UP.rotated(randf() * TAU) * 100
