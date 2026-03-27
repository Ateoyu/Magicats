class_name Enemy
extends CharacterBody2D

@export_category("Base Enemy Stats")
@export var max_health: int = 100
@export var attack_power: int = 10
@export var movement_speed: int = 50
var current_health: int

@onready var player = get_tree().get_first_node_in_group("player")

@onready var loot_base = get_tree().get_first_node_in_group("loot")
var experience_gem = preload("res://scenes/experienceGem.tscn")
@export var experience: int = 1

func _ready() -> void:
	current_health = max_health
	
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()
		
func die() -> void:
	var new_gem = experience_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	# add animation here for death.
	queue_free() 

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
