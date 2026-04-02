class_name Enemy
extends CharacterBody2D

@export_category("Base Enemy Stats")
@export var max_health: int = 100
@export var attack_power: int = 10
@export var movement_speed: int = 50
var current_health: int

var player: Player
var loot_base: Node2D

var experience_gem = preload("res://scenes/loot/experienceGem.tscn")
var health_item = preload("res://scenes/loot/healthItem.tscn")

@export var experience_dropped: int = 1
@export var health_dropped: int = 4

func _ready() -> void:
	current_health = max_health
	scene_file_path = get_scene_file_path()
	add_to_group("enemy")
	
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()
		
func die() -> void:
	var new_gem = experience_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.pickup_value = experience_dropped
	loot_base.call_deferred("add_child", new_gem)
	
	#if randf() < 0.05:
	var new_health_item = health_item.instantiate()
	var health_offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))
	new_health_item.global_position = global_position + health_offset
	new_health_item.pickup_value = health_dropped
	loot_base.call_deferred("add_child", new_health_item)
	
	queue_free() 

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed

	if direction.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
