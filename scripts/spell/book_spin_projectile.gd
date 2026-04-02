class_name BookSpinProjectile
extends Area2D

var player: CharacterBody2D
var damage: int
var distance: float
var angular_velocity: float
var angle: float
var size: float

func initialize(p_player: CharacterBody2D, p_damage: int, p_distance: float, p_angular_velocity: float, p_angle: float, p_size: float) -> void:
	self.player = p_player
	self.damage = p_damage
	self.distance = p_distance
	self.angular_velocity = p_angular_velocity
	self.angle = p_angle
	self.size = p_size

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	add_to_group("spell")

	$Sprite2D.scale = Vector2(size, size)
	$CollisionShape2D.scale = Vector2(size, size)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		queue_free()
		return

	angle += angular_velocity * delta
	var offset: Vector2 = Vector2(cos(angle), sin(angle)) * distance
	global_position = player.global_position + offset
	rotation = angle + PI/2

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().take_damage(damage)
