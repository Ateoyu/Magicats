class_name SpellManager
extends Node2D

@onready var player: Node = get_parent()
var equipped_spells: Array[Spell] = []

func _ready() -> void:
	var ice_spear: IceSpear = IceSpear.new(self, player)
	equipped_spells.append(ice_spear)
	var lightning_strike: LightningStrike = LightningStrike.new(self, player)
	#equipped_spells.append(lightning_strike)

func _process(delta: float) -> void:
	for spell in equipped_spells:
		spell.cooldown_remaining -= delta
		if spell.cooldown_remaining <= 0:
			spell.cast()
			spell.cooldown_remaining = spell.cooldown
