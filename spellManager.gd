extends Node

var equipped_spells: Array[Spell] = []

# called every frame to countdown spells
func _process(delta: float) -> void:
	for spell in equipped_spells:
		spell.cooldown_remaining -= delta
		if spell.cooldown_remaining <= 0:
			# signal to fire the spell
			spell.cooldown_remaining = spell.cooldown
