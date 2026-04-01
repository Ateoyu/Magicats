class_name BloodVortexProjectile
extends Area2D

var damage: int
var aoe_radius: float
var damage_tick_rate: float
var duration: float

var tick_timer: float = 0.0
var active_timer: float = 0.0
var is_active: bool = false

func initialize(p_damage: int, p_aoe_radius: float, p_damage_tick_rate: float, p_duration: float) -> void:
	self.damage = p_damage
	self.aoe_radius = p_aoe_radius
	self.damage_tick_rate = p_damage_tick_rate
	self.duration = p_duration

func _ready() -> void:
	add_to_group("spell")

	var sprite_size: float = 128.0
	var target_scale: float = (aoe_radius * 2.0) / sprite_size
	$AnimatedSprite2D.scale = Vector2(target_scale, target_scale)
	$CollisionShape2D.shape.radius = aoe_radius

	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$AnimatedSprite2D.play("start")

	monitoring = false

func _process(delta: float) -> void:
	if not is_active:
		return

	tick_timer += delta
	active_timer += delta

	if tick_timer >= damage_tick_rate:
		tick_timer -= damage_tick_rate
		damage_enemies_in_area()

	if active_timer >= duration:
		is_active = false
		monitoring = false
		$AnimatedSprite2D.play("end")

func damage_enemies_in_area() -> void:
	for area in get_overlapping_areas():
		if area.get_parent() is Enemy:
			area.get_parent().take_damage(damage)

func _on_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"start":
			$AnimatedSprite2D.play("active")
			monitoring = true
			is_active = true
		"end":
			queue_free()
