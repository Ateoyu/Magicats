class_name IceSpearProjectile
extends Area2D

var target: Vector2
var angle: Vector2
var damage: int
var velocity: int
var hp: int

func initialize(p_target: Vector2, p_damage: int, p_velocity: int, p_hp: int) -> void:
	target = p_target
	damage = p_damage
	velocity = p_velocity
	hp = p_hp

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position += angle * velocity * delta

func enemy_hit(charge: int = 1) -> void:
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().take_damage(damage)
		enemy_hit()


func _on_timer_timeout() -> void:
	queue_free()
