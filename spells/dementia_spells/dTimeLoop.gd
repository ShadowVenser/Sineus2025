extends DementiaSpell
class_name TimeLoopDementia

func _init():
	delay = 2
	period = 0
	casts = 1
	#picture = 
	
	spell_name = "Time loop"
	description = "Go back in time to make spells work again"
	dementia_spell_name =  ["Time loop", "Time soup", "Tiny hop", "????"]
	dementia_description = ["Go back in time to make spells work again", "Make some expired soup", "Make a really small jump", "????????"]

	damage = 0
	heal = 0
	type = 0


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	pl.get_parent().get_parent().play_animation("Time hold")
	rythm.time_jump(-delay-period*casts)
	

# Метод для применения эффектов
func apply() -> void:
	pass
	
