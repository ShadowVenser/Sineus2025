extends Spell

class_name ScorchedEarthSpell


func _init():
	delay = 2
	period = 1
	casts = 3
	#picture = 

	spell_name = "Scorched earth"
	damage = 3
	heal = 0
	type = -1
	description = "Burn ground underneath the enemy"


# Метод для записывания в мировое время
func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов 
func apply() -> void:
	enemy.take_damage(damage, type)
	
