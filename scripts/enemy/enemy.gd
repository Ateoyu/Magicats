class_name Enemy
extends CharacterBody2D

@export_category("Base Stats")
@export var max_health: int = 100
@export var attack_power: int = 10
@export var movement_speed: int = 50
var current_health: int

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	current_health = max_health
	
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()
		
func die() -> void:
	# add animation here for death.
	queue_free() 

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
