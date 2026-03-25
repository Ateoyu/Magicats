@abstract
class_name Spell
extends Area2D

var level: int 
var damage: int
#var velocity: int = 100
#var attack_size: float = 1.0
#var attack_speed: float = 1.0
var cooldown: float 
var cooldown_remaining: float

@onready var player: Player = $Player

func _init(p_level: int, p_damage: int, p_cooldown: float) -> void:
	self.level = p_level
	self.damage = p_damage
	self.cooldown = p_cooldown

@abstract func fire(target: Array[Enemy]) -> void
