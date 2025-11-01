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
	print("adding spell to "+str(current_tick+round_diff))
	get_tick(current_tick+round_diff).add_spell(spell)
	
#true - spells to cast; false - no spells	
func next_tick()-> bool:
	var spellsPresent = get_tick(current_tick).prepare_applying_spells()
	if !spellsPresent:
		current_tick+=1
		print("current tick now "+str(current_tick))
	return spellsPresent
	
	
#true - spells to cast; false - no spells	
func apply_tick_spell() -> bool:
	var spellsPresent = get_tick(current_tick).apply_next_spell()
	if !spellsPresent:
		current_tick+=1
		print("current tick now "+str(current_tick))
	return spellsPresent
	
func get_next_casted() -> String:
	return get_tick(current_tick).next_spell().spell_name
	
	
func time_jump(diff: int) -> void:
	current_tick += diff
	
func tick_remove(diff: int) -> void:
	if timeline.size() > current_tick+diff:
		timeline.remove_at(current_tick+diff)
		
func tick_duplicate(diff: int) -> void:
	if timeline.size() > current_tick+diff:
		timeline.insert(current_tick+diff+1, timeline[current_tick+diff])
