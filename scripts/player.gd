class_name Player
extends CharacterBody2D

signal player_died
signal health_changed
signal update_experience_bar

@export var movement_speed: float = 500
@export var max_health: int = 100
@onready var current_health: int = max_health
@onready var sprite: AnimatedSprite2D = %sprite

@onready var spell_manager: SpellManager = $SpellManager

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0

var enemy_close: Array[Enemy] = []

var character_direction: Vector2

func _ready() -> void:
	update_experience_bar.emit()

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
	sprite.animation = "death"
	player_died.emit()

func _on_pickup_range_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collection_area_area_entered(area: ExperienceGem) -> void:
	if area.is_in_group("loot"):
		ExperienceManager.add_experience(area.collect())


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:	
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
