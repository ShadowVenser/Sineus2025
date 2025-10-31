extends Node
class_name RythmTick

var spells: Array[Spell] = []

func add_spell(spell: Spell) -> void:
	var is_done = false
	for i in range(len(spells)):
		if (spell.type != spells[i].type):
			spells.erase(i)
			is_done = false
			break
	if (!is_done):
		spells.append(spell)

func cast_current_spells() -> void:
	for spell in spells:
		spell.apply()
