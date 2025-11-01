extends Spell
class_name DementiaSpell

var dementia_spell_name: Array[String]
var dementia_description: Array[String]

func get_spell_name()->String:
	return dementia_spell_name[rng.randi_range(0, dementia_spell_name.size()-1)]
	
func get_spell_description()->String:
	return dementia_description[rng.randi_range(0, dementia_description.size()-1)]
	
