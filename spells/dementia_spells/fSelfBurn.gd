extends DementiaSpell

class_name SelfBurnEffect


func _init():
	delay = 0
	period = 0
	casts = 1
	#picture = 

	spell_name = "Self burn"
	dementia_spell_name = [
		"Self burn", 
		"Super burn", 
		"Self steam",
		 "????"
	]
	dementia_description = [
		"you burn yourself",
		"you burn everything around",
		"you release some cool steam",
		"??????"
	]
	damage = 3
	heal = 0
	type = -1
	description = "You got burned!"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	player.take_damage(damage)
	enemy.take_damage(0, "Weak")
	
