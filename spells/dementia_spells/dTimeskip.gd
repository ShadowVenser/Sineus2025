extends DementiaSpell
class_name TimeSkipDementia

func _init():
	delay = 1
	period = 2
	casts = 1
	#picture = 
	
	spell_name = "Timeskip"
	description = "Skip spells, applied next round"
	dementia_spell_name =  ["Timeskip", "Timesleep", "Timeslay", "????"]
	dementia_description = ["Skip spells, applied next round", "Sleep next round", "Slay next round", "????????"]

	damage = 0
	heal = 0
	type = 0


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	pl.get_parent().get_parent().play_animation("Time hold")
	for i in range(casts):
		rythm.tick_remove(delay + period*i)
	

# Метод для применения эффектов
func apply() -> void:
	pass
	
