class_name SpellManager
extends Node2D

@onready var player: Node = get_parent()

var all_available_spells: Array[Spell] = []
var equipped_spells: Array[Spell] = []

func _ready() -> void:
	append_all_spells_to_list(all_available_spells)
	equipped_spells.append(all_available_spells[0])

func _process(delta: float) -> void:
	for spell in equipped_spells:
		spell.cooldown_remaining -= delta
		if spell.cooldown_remaining <= 0:
			spell.cast()
			spell.cooldown_remaining = spell.cooldown
			
func append_all_spells_to_list(spell_list: Array) -> void:
	all_available_spells.append(IceSpear.new(self, player))
	all_available_spells.append(LightningStrike.new(self, player))
	all_available_spells.append(BloodVortex.new(self, player))
	all_available_spells.append(BookSpin.new(self, player))

func reset() -> void:
	all_available_spells.clear()
	equipped_spells.clear()
	append_all_spells_to_list(all_available_spells)
	equipped_spells.append(all_available_spells[0])

func get_upgradable_spells() -> Array[Spell]:
	return all_available_spells.filter(func(spell): return spell.level < Spell.MAX_LEVEL)

func upgrade_spell(spell: Spell) -> void:
	if spell.level >= Spell.MAX_LEVEL:
		return
	if spell.level == 0:
		equipped_spells.append(spell)
	spell.level += 1
	spell.apply_level_stats()
	print(spell.name, " upgraded to level ", spell.level)
