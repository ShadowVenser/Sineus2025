extends Spell

class_name FreezeSpell


func _init():
	delay = 2
	period = 1
	casts = 1
	#picture = 

	spell_name = "Freeze"
	damage = 3
	heal = 0
	type = 1
	description = "Freeze your enemy, so he cant move"


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	super.cast(pl, en, rythm)
	

# Метод для применения эффектов
func apply() -> void:
	enemy.take_damage(damage, type)
	#TODO ДОБАВИТЬ ЭФФЕКТ!
	
