@abstract
class_name Spell
extends Resource

const MAX_LEVEL: int = 5

var name: String
var level: int = 1
var damage: int
var cooldown: float
var cooldown_remaining: float

var spell_manager: Node2D
var player: CharacterBody2D

func _init(p_name: String, p_level: int, p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	self.name = p_name
	self.level = p_level
	self.cooldown_remaining = 0.0
	self.spell_manager = p_spell_manager
	self.player = p_player

@abstract func cast() -> void
@abstract func apply_level_stats() -> void

func get_upgrade_description() -> String:
	return "Level up " + name + " to Level " + str(level + 1)
