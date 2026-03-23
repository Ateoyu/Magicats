extends CharacterBody2D

class_name Player

signal health_changed
signal experience_changed
signal level_up(new_level)

@export var movement_speed: float = 500
@export var max_health: int = 100
@onready var current_health: int = max_health
@onready var sprite = %sprite

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0

var character_direction: Vector2

func _ready() -> void:
	experience_changed.emit()

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

func _on_collection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		add_experience(gem_experience)

#ideally everything below would be in 'experience_manager.gd'
func add_experience(amount: int) -> void:
	var experience_required = calculate_experience_cap()
	collected_experience += amount
	if experience + collected_experience >= experience_required:
		collected_experience -= experience_required - experience
		experience_level += 1
		level_up.emit(experience_level)
		experience_changed.emit()
		experience = 0
		experience_required = calculate_experience_cap()
		add_experience(0)
	else:
		experience += collected_experience
		collected_experience = 0
	experience_changed.emit()

func calculate_experience_cap() -> int:
	var experience_cap: int = experience_level
	
	if experience_level < 20:
		experience_cap = experience_level * 5
	elif experience_level < 40:
		experience_cap = 95 * (experience_level - 19) * 8
	else:
		experience_cap = 255 + (experience_level - 39) * 12
	return experience_cap
