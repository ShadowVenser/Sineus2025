extends Node
class_name RythmTick

var spells: Array[Spell] = []
var applying: bool = false
var current_spell: int = 0

func add_spell(spell: Spell) -> void:
	var is_added = true
	for i in range(len(spells)):
		if (spell.type == -spells[i].type) or (spell.type==0):
			spells.remove_at(i)
			is_added = false
			break
	if (is_added):
		spells.append(spell)
		print("added " + str(spell.spell_name))

#func apply_spells() -> void:
#	for spell in spells:
#		spell.apply()

func prepare_applying_spells() -> bool:
	print("checkin spell tick: " + str(spells.size()))
	if spells.size()>0:
		applying = true
		current_spell = 0
		return true
	return false

func apply_next_spell() -> bool:
	print("next spell")
	spells[current_spell].apply()
	if spells.size()>current_spell+1:
		current_spell+=1
		return true
	else:
		applying = false
		return false
	
func next_spell_name() -> String:
	return spells[current_spell].spell_name
