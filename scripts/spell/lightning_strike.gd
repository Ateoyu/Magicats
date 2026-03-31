class_name LightningStrike
extends Spell

var projectile_count: int
var aoe_radius: float
var lightning_projectile: PackedScene = preload("res://scenes/spell/lightningStrike.tscn")

func _init(p_spell_manager: Node2D = null, p_player: CharacterBody2D = null) -> void:
	super("Lightning Strike", 1, 10, 2.0, p_spell_manager, p_player)
	self.projectile_count = 1
	self.aoe_radius = 50.0

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
