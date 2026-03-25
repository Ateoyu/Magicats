class_name IceSpear
extends Spell

var velocity: int
var projectile_count: int
var ice_spear: PackedScene = preload("res://scenes/spell/iceSpear.tscn")

func _init(p_level) -> void:
	super(p_level, 5, 2)
	self.velocity = 100
	self.projectile_count = 1
	
func _ready() -> void:
	global_position = player.global_position

func fire(target: Array[Enemy]) -> void:
	print("Firing Ice Spear")
	for i in projectile_count:
		var ice_spear_projectile: Node = ice_spear.instantiate()
		ice_spear_projectile.position = position
		ice_spear_projectile.target = get_random_target(target)
		add_child(ice_spear_projectile)
		look_at(ice_spear_projectile.target)
		

		
		
func get_random_target(target_array: Array[Enemy]) -> Vector2:
	return target_array.pick_random().global_position
