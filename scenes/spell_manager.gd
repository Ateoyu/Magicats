class_name SpellManager
extends Node2D

@onready var player = get_parent()

var ice_spear = preload("res://scenes/spell/iceSpear.tscn")
@onready var ice_spear_timer = get_node("%IceSpearTimer")
@onready var ice_spear_attack_timer = get_node("%IceSpearAttackTimer")

var ice_spear_ammo = 0
var ice_spear_base_ammo = 1
var ice_spear_attack_speed = 1.5
var ice_spear_level = 1

func attack():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()

func get_random_target():
	if player.enemy_close.size() > 0:
		return player.enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_attack_timer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_attack = ice_spear.instantiate()
		ice_spear_attack.position = player.global_position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -= 1
		
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()
