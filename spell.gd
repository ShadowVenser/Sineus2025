extends Node
class_name Spell

var spell_name: String
var delay: int
var period: int
var casts: int
var icon: Texture2D
var description: String

	
func cast(player: Player, enemy: Enemy, rythm: WorldRythm) -> void:
	for i in range(casts):
		rythm.add(self, delay + period*i)
		print("добавить в такт " + str(delay + period*i))
		

# Метод для применения эффектов (должен быть переопределен)
func apply() -> void:
	print("применилось в конкретный такт")
