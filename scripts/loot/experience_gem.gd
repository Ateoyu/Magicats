class_name ExperienceGem 
extends Loot

var spr_amethyst = preload("res://assets/pickups/amethyst.png")
var spr_ruby = preload("res://assets/pickups/ruby.png")
var spr_diamond = preload("res://assets/pickups/diamond.png")

func _init():
	pickup_type = "experience"

func get_texture_for_value(value: int) -> Texture2D:
	if value < 5:
		return spr_amethyst
	elif value < 25:
		return spr_ruby
	else:
		return spr_diamond
