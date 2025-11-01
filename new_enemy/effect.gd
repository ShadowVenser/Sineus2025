extends Node
class_name Effect

const effects_ttl = {
	"Stun": 1,
	"Burn": 2,
	"Weak": 3
}
const weak_mod = 1
const burn_mod = 1

var effects = {
	1: 0,
	2: 0,
	3: 0
}

func add_effect(effect_name: String) -> void:
	effects[effects_ttl[effect_name]] = effects_ttl[effect_name]
	print("added "+effect_name)

func zero():
	for key in effects.keys():
		effects[key] = 0

#func get_effects() -> int:
	#var code = 0
	#for key in effects.keys():
		#if (effects[key] > 0):
			#code |= key
	#return code

func get_stun_mod() -> int:
	return 1 - effects[1]
	
func get_burn_mod() -> int:
	return burn_mod * effects[2]
	
func get_weak_mod() -> int:
	if (effects[3] > 0):
		return effects[3] / 2 + weak_mod
	return 0

func effect_applied() -> void:
	for effect in effects.keys():
		effects[effect] = max(0, effects[effect] - 1)
