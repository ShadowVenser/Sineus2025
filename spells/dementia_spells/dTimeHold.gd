extends DementiaSpell
class_name TimeHoldDementia

func _init():
	delay = 1
	period = 0
	casts = 1
	#picture = 
	
	spell_name = "Time hold"
	description = "Duplicate next round"
	dementia_spell_name =  ["Time hold", "Time sold", "Tine told", "????"]
	dementia_description = ["Duplicate next round", "Sell next round", "Tell some tine", "????????"]

	damage = 0
	heal = 0
	type = 0


func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	pl.get_parent().get_parent().play_animation("Time hold")
	for i in range(casts):
		rythm.tick_duplicate(delay + period*i)
	

# Метод для применения эффектов
func apply() -> void:
	pass
	
