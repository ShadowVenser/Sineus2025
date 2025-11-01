extends Spell

class_name FireballSpell


func _init():
	delay = 0
	period = 0
	casts = 1
	#picture = 
	
	crit_good_chance = 0.1
	crit_bad_chance = 0.1

	spell_name = "Fireball"
	damage = 5
	heal = 0
	type = -1
	description = "Throw a basic fireball next round"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	enemy.take_damage(damage)
	super.apply()
	
