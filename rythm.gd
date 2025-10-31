extends Node
class_name WorldRythm

var timeline: Array[RythmTick] = []
var current_tick = 0

func get_tick(tick:int) -> RythmTick:
	if timeline.size() < tick+1:
		timeline.resize(tick+5)
	return timeline[tick]
	

func add(spell: Spell, round_diff:int) -> void:
	get_tick(current_tick+round_diff).add_spell(spell)
	
func next_tick() -> void:
	get_tick(current_tick).apply_spells()
	current_tick+=1
	
func time_jump(diff: int) -> void:
	current_tick += diff
	
