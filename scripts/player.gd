extends CharacterBody2D

class_name Player

signal health_changed

@export var movement_speed: float = 500
@export var max_health: int = 100
@onready var current_health: int = max_health
@onready var sprite: AnimatedSprite2D = %sprite

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0

var ice_spear: PackedScene = preload("res://scenes/spell/iceSpear.tscn")
@onready var ice_spear_timer: Node = get_node("%IceSpearTimer")
@onready var ice_spear_attack_timer: Node = get_node("%IceSpearAttackTimer")
var ice_spear_ammo: int = 0
var ice_spear_base_ammo: int = 1
var ice_spear_attack_speed: float = 1.5
var ice_spear_level: int = 1
var enemy_close: Array[Enemy] = []

var character_direction: Vector2

func _ready() -> void:
	attack()

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized() # so diagonal isnt faster
	
	if character_direction.x > 0: 
		sprite.flip_h = true
	elif character_direction.x < 0: 
		sprite.flip_h = false
	
	if character_direction:
		velocity = character_direction * movement_speed
		if sprite.animation != "run": 
			sprite.animation = "run"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if sprite.animation != "idle": 
			sprite.animation = "idle"
	
	move_and_slide()

func take_damage(amount: int) -> void:
	current_health -= amount
	health_changed.emit()
	
	if current_health <= 0:
		die()

func heal(amount: int)  -> void:
	current_health += amount
	health_changed.emit()

func die() -> void:
	queue_free()

#broken functionality for crystals moving towards player:
#func _on_pickup_range_area_area_entered(area: Area2D) -> void:
	#if area.is_in_group("loot"):
		#area.target = self

func _on_collection_area_area_entered(area: ExperienceGem) -> void:
	if area.is_in_group("loot"):
		ExperienceManager.add_experience(area.collect())

#ice spear stuff
func attack():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_attack_timer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_attack = ice_spear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -= 1
		
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
