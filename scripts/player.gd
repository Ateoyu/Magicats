class_name Player
extends CharacterBody2D

signal player_died
signal health_changed

var default_pickup_range: float
@export var pickup_range: float = 200.0

var default_movement_speed: float
@export var movement_speed: float = 250

var default_max_health: int
@export var max_health: int = 100:
	set(value):
		max_health = value
		health_changed.emit()
@onready var current_health: int = max_health

@onready var sprite: AnimatedSprite2D = %sprite

@onready var spell_manager: SpellManager = $SpellManager

@onready var collect_experience_gem_sound: AudioStreamPlayer = $CollectXp
@onready var collect_health_sound: AudioStreamPlayer = $CollectHealth

@onready var pickup_range_collision: CollisionShape2D = $PickupRangeArea/PickupRangeCollision

var enemy_close: Array[Enemy] = []

var character_direction: Vector2

func _ready() -> void:
	default_movement_speed = movement_speed
	default_max_health = max_health
	default_pickup_range = pickup_range

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
	current_health = min(current_health + amount, max_health)
	health_changed.emit()

func die() -> void:
	sprite.animation = "death"
	player_died.emit()

func _on_pickup_range_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		if area is ExperienceGem:
			collect_experience_gem_sound.play()
			var exp_value = area.collect()
			ExperienceManager.add_experience(exp_value)
		elif area is HealthItem:
			collect_health_sound.play()
			heal(area.collect())

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:	
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
