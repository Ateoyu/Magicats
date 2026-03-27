@abstract
class_name Spell
extends Resource

var level: int = 1
var damage: int
var cooldown: float
var cooldown_remaining: float

var spell_manager: Node2D
var player: CharacterBody2D

func _init(p_level: int, p_damage: int, p_cooldown: float, p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	self.level = p_level
	self.damage = p_damage
	self.cooldown = p_cooldown
	self.cooldown_remaining = 0.0
	self.spell_manager = p_spell_manager
	self.player = p_player

@abstract func cast() -> void
