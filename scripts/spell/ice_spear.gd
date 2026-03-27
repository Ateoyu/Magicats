class_name IceSpear
extends Spell

var velocity: int
var projectile_count: int
var projectile_hp: int
var ice_spear_projectile: PackedScene = preload("res://scenes/spell/iceSpear.tscn")

func _init(p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	super(1, 5, 0.75, p_spell_manager, p_player)
	self.velocity = 250
	self.projectile_count = 1
	self.projectile_hp = 1

func cast() -> void:
	for i in projectile_count:
		var target_position: Vector2 = get_random_target()

		var projectile: Node = ice_spear_projectile.instantiate()
		projectile.global_position = player.global_position
		projectile.initialize(target_position, damage, velocity, projectile_hp)

		spell_manager.add_child(projectile)

func get_random_target() -> Vector2:
	if player.enemy_close.size() > 0:
		return player.enemy_close.pick_random().global_position
	else:
		return player.global_position + Vector2.UP.rotated(randf() * TAU) * 100
