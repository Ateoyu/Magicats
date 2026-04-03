class_name BookSpin
extends Spell

var distance: float
var velocity: float
var size: float
var projectile_count: int
var active_projectiles: Array[BookSpinProjectile] = []
var book_spin_projectile: PackedScene = preload("res://scenes/spell/bookSpin.tscn")

func _init(p_spell_manager: Node2D, p_player: CharacterBody2D) -> void:
	super("Book Spin", 0, p_spell_manager, p_player)
	apply_level_stats()

func apply_level_stats() -> void:
	match level:
		1:
			damage = 10
			cooldown = 999999.0
			velocity = 200
			projectile_count = 1
			size = 1.0
			distance = 100
		2:
			damage = 10
			cooldown = 999999.0
			velocity = 225
			projectile_count = 2
			size = 1.2
			distance = 110
		3:
			damage = 13
			cooldown = 999999.0
			velocity = 250
			projectile_count = 3
			size = 1.4
			distance = 120
		4:
			damage = 16
			cooldown = 999999.0
			velocity = 275
			projectile_count = 4
			size = 1.6
			distance = 135
		5:
			damage = 20
			cooldown = 999999.0
			velocity = 300
			projectile_count = 5
			size = 1.8
			distance = 150
	clear_projectiles()
	cooldown_remaining = 0.0

func get_upgrade_description() -> String:
	match level + 1:
		2: return "Adds an extra book and increases speed"
		3: return "Adds another book and increases rotation distance"
		4: return "Adds a fourth book for better coverage"
		5: return "Maximum books and devastating damage"
		_: return "Level up " + name + " to Level " + str(level + 1)

func cast() -> void:
	var angular_velocity: float = velocity / distance
	for i in projectile_count:
		var projectile: BookSpinProjectile = book_spin_projectile.instantiate()
		var initial_angle: float = (float(i) * 2.0 * PI) / projectile_count
		projectile.initialize(player, damage, distance, angular_velocity, initial_angle, size)
		spell_manager.add_child(projectile)
		active_projectiles.append(projectile)

func clear_projectiles() -> void:
	for projectile in active_projectiles:
		if is_instance_valid(projectile):
			projectile.queue_free()
	active_projectiles.clear()	