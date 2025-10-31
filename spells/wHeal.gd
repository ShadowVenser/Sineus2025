extends Spell

class_name HealSpell

func _init():
	delay = 1
	period = 0
	casts = 1
	#picture = 

	spell_name = "Heal"
	damage = 0
	heal = 4
	type = 1
	description = "Heal yourself next round with water magic"


# Метод для записывания в мировое время
func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	#.super.cast(pl, en, rythm)
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	player.heal(heal)
	
