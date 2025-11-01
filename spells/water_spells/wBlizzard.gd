extends Spell

class_name BlizzardSpell


func _init():
	delay = 1
	period = 1
	casts = 5
	#picture = 

	spell_name = "Blizzard"
	damage = 3
	heal = 0
	type = 1
	description = "Summon powerfull blizzard"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	enemy.take_damage(damage)
	player.take_damage(damage/3)
	
