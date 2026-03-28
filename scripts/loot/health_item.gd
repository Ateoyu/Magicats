class_name HealthItem 
extends Loot

var spr_chicken = preload("res://assets/pickups/chicken_wing.png")
var spr_fish = preload("res://assets/pickups/fish.png")
var spr_catmint = preload("res://assets/pickups/catmint.png")
var spr_mushroom = preload("res://assets/pickups/mushroom.png")
var spr_potion = preload("res://assets/pickups/health_potion.png")

func _init():
	pickup_type = "health"

func get_texture_for_value(value: int) -> Texture2D:
	if value < 5:
		return spr_chicken
	elif value < 10:
		return spr_fish
	elif value < 25:
		return spr_catmint
	elif value < 50:
		return spr_mushroom
	else:
		return spr_potion
