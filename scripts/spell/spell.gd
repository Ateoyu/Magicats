class_name Spell
extends Area2D

@export_category("Base Spell Stats")
@export var level: int = 1
@export var hp: int = 1
@export var speed: int = 100
@export var damage: int = 5
@export var attack_size: float = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	
	area_entered.connect(_on_area_entered)

	match level:
		1:
			hp = 1
			speed = 100
			var damage = 5
			var knockback_amount = 100
			var attack_size = 1.0

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().take_damage(damage)
		queue_free()
