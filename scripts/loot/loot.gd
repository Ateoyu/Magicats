class_name Loot 
extends Area2D

var pickup_value: int = 1
var pickup_type: String

var target = null
var speed: float = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func get_texture_for_value(value: int) -> Texture2D:
	return null

func _ready():
	var texture = get_texture_for_value(pickup_value)
	add_to_group("loot")
	scene_file_path = get_scene_file_path()
	if texture:
		sprite.texture = texture


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed) 
		speed += 3 * delta

func collect():
	collision.call_deferred("set", "disabled", true)
	queue_free()
	return pickup_value	
