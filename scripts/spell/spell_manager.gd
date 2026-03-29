class_name SpellManager
extends Node2D

@onready var player: Node = get_parent()

@export var all_available_spells: Array[Spell] = []
var equipped_spells: Array[Spell] = []

func _ready() -> void:
	var ice_spear: IceSpear = IceSpear.new(self, player)
	equipped_spells.append(ice_spear)
	var lightning_strike: LightningStrike = LightningStrike.new(self, player)
	equipped_spells.append(lightning_strike)

func _process(delta: float) -> void:
	for spell in equipped_spells:
		spell.cooldown_remaining -= delta
		if spell.cooldown_remaining <= 0:
			spell.cast()
			spell.cooldown_remaining = spell.cooldown

func get_upgradable_spells() -> Array[Spell]:
	return all_available_spells.filter(func(spell): return spell.level < 5)

func upgrade_spell(spell: Spell):
	if spell.level == 0:
		equipped_spells.append(spell)
	spell.level += 1
	print("Spell levelled up")
	# logic for upgrades..
