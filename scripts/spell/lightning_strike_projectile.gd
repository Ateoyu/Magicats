class_name LightningStrikeProjectile
extends Area2D

var target: Vector2
var damage: int
var aoe_radius: float

func initialize(p_target: Vector2, p_damage: int, p_aoe_radius: float) -> void:
	self.target = p_target
	self.damage = p_damage
	self.aoe_radius = p_aoe_radius

func _ready() -> void:
	global_position = target

	var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
	animated_sprite.play("strike")
	animated_sprite.animation_finished.connect(_on_animation_finished)

	var collision_shape: CollisionShape2D = $CollisionShape2D
	collision_shape.shape.radius = aoe_radius

	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().take_damage(damage)

func _on_animation_finished() -> void:
	queue_free()
