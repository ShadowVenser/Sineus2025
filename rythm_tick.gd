extends Node
class_name RythmTick

var spells: Array[Spell] = []

func add_spell(spell: Spell) -> void:
	var is_added = true
	for i in range(len(spells)):
		if (spell.type == spells[i].type) or (spell.type==0):
			spells.remove_at(i)
			is_added = false
			break
	if (is_added):
		spells.append(spell)

func apply_spells() -> void:
	for spell in spells:
		spell.apply()
