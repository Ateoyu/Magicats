class_name ExperienceGem extends Area2D
@export var experience: int = 1

var spr_amethyst = preload("res://assets/pickups/amethyst.png")
var spr_ruby = preload("res://assets/pickups/ruby.png")
var spr_diamond = preload("res://assets/pickups/diamond.png")

var target = null
var speed: float = 0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_amethyst
	else:
		sprite.texture = spr_ruby

#broken functionality for crystals moving towards player:
#func _physics_process(delta: float) -> void:
	#if target != null:
		#global_position = global_position.move_toward(target.global_position, speed)
		#speed += 2 * delta

func collect():
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience	
