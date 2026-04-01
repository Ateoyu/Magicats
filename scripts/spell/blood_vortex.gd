class_name BloodVortex
extends Spell

var aoe_radius: float
var damage_tick_rate: float
var duration: float
var blood_vortex_projectile: PackedScene = preload("res://scenes/spell/bloodVortex.tscn")

func _init(p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	super("Blood Vortex", 0, p_spell_manager, p_player)
	apply_level_stats()
	
func apply_level_stats() -> void:
	match level:
		1:
			damage = 3
			cooldown = 6.0
			aoe_radius = 150.0
			damage_tick_rate = 0.5
			duration = 3.0
		2:
			damage = 4
			cooldown = 5.5
			aoe_radius = 175.0
			damage_tick_rate = 0.45
			duration = 3.5
		3:
			damage = 5
			cooldown = 5.0
			aoe_radius = 200.0
			damage_tick_rate = 0.4
			duration = 4.0
		4:
			damage = 7
			cooldown = 4.5
			aoe_radius = 250.0
			damage_tick_rate = 0.35
			duration = 4.5
		5:
			damage = 10
			cooldown = 4.0
			aoe_radius = 300.0
			damage_tick_rate = 0.25
			duration = 5.0

func get_upgrade_description() -> String:
	match level + 1:
		2: return "Blood Vortex grows wider and ticks faster"
		3: return "Blood Vortex lasts longer with increased damage"
		4: return "Blood Vortex becomes a deadly maelstrom"
		5: return "Blood Vortex consumes all in its path"
		_: return ""

func cast() -> void:
	var projectile: BloodVortexProjectile = blood_vortex_projectile.instantiate()
	projectile.global_position = player.global_position
	projectile.initialize(damage, aoe_radius, damage_tick_rate, duration)
	spell_manager.add_child(projectile)
	
