class_name LightningStrike
extends Spell

var projectile_count: int
var aoe_radius: float
var lightning_projectile: PackedScene = preload("res://scenes/spell/lightningStrike.tscn")

func _init(p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	super("Lightning Strike", 0, p_spell_manager, p_player)
	apply_level_stats()

func apply_level_stats() -> void:
	match level:
		1:
			damage = 10
			cooldown = 2.0
			projectile_count = 1
			aoe_radius = 50.0
		2:
			damage = 14
			cooldown = 1.85
			projectile_count = 1
			aoe_radius = 60.0
		3:
			damage = 18
			cooldown = 1.7
			projectile_count = 2
			aoe_radius = 70.0
		4:
			damage = 22
			cooldown = 1.5
			projectile_count = 3
			aoe_radius = 85.0
		5:
			damage = 28
			cooldown = 1.2
			projectile_count = 5
			aoe_radius = 110.0

func get_upgrade_description() -> String:
	match level + 1:
		2: return "Lightning Strike deals more damage with a wider blast"
		3: return "Lightning Strike hits 2 targets simultaneously"
		4: return "Lightning Strike calls down 3 bolts"
		5: return "Lightning Strike becomes a devastating storm"
		_: return ""

func cast() -> void:
	var targets_hit: Array[Enemy] = []

	for i in projectile_count:
		var target_enemy: Enemy = get_unique_target(targets_hit)
		if target_enemy != null:
			targets_hit.append(target_enemy)
			
			var projectile: LightningStrikeProjectile = lightning_projectile.instantiate()
			projectile.global_position = target_enemy.global_position
			projectile.initialize(target_enemy.global_position, damage, aoe_radius)
	
			spell_manager.add_child(projectile)

func get_unique_target(already_targeted: Array) -> Enemy :
	if player.enemy_close.size() == 0:
		return null

	var available_enemies: Array[Enemy] = []
	for enemy in player.enemy_close:
		if not already_targeted.has(enemy):
			available_enemies.append(enemy)

	if available_enemies.size() > 0:
		return available_enemies.pick_random()
	else:
		return null
