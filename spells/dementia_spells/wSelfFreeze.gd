extends DementiaSpell

class_name SelfFreezeEffect


func _init():
	delay = 0
	period = 0
	casts = 1
	#picture = 

	spell_name = "Self freeze"
	dementia_spell_name = [
		"Self freeze", 
		"Super freeze", 
		"Rain yourself",
		 "????"
	]
	dementia_description = [
		"you freeze yourself!",
		"you freeze everything around you",
		"you release some nice rain to become cool",
		"??????"
	]
	damage = 3
	heal = 0
	type = 1
	description = "You froze yourself!"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	player.take_damage(damage)
	enemy.take_damage(0, "Weak")
	
