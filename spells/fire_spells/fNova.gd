extends Spell

class_name NovaSpell


func _init():
	delay = 0
	period = 0
	casts = 1
	#picture = 

	spell_name = "Fire nova"
	damage = 8
	heal = 0
	type = -1
	description = "Explode yourself to burn enemy even more"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	enemy.take_damage(damage)
	player.take_damage(damage/2)
	
