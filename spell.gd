extends Node
class_name Spell

var spell_name: String
var delay: int
var period: int
var casts: int
var icon: Texture2D
var description: String
var player: Player
var enemy: Enemy

var damage: int
var heal: int
# 1 - вода, -1 - огонь, 0 - нейтральные
var type: int

	
func cast(pl: Player, en: Enemy, rythm: WorldRythm) -> void:
	player = pl
	enemy = en
	for i in range(casts):
		rythm.add(self, delay + period*i)
		print("добавить в такт " + str(delay + period*i))
		

# Метод для применения эффектов (должен быть переопределен)
func apply() -> void:
	
	print("применилось в конкретный такт")
