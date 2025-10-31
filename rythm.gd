extends Node
class_name WorldRythm

var timeline: Array[RythmTick] = []
var current_tick = 0

func get_tick(tick:int) -> RythmTick:
	if timeline.size() < tick+1:
		while (timeline.size() < tick+5):
			timeline.append(RythmTick.new())
	return timeline[tick]
	

func add(spell: Spell, round_diff:int) -> void:
	get_tick(current_tick+round_diff).add_spell(spell)
	
func next_tick() -> void:
	get_tick(current_tick).apply_spells()
	current_tick+=1
	
func time_jump(diff: int) -> void:
	current_tick += diff
	
func tick_remove(diff: int) -> void:
	if timeline.size() > current_tick+diff:
		timeline.remove_at(current_tick+diff)
		
func tick_duplicate(diff: int) -> void:
	if timeline.size() > current_tick+diff:
		timeline.insert(current_tick+diff+1, timeline[current_tick+diff])
