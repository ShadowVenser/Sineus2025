extends Control

signal clicked(spell_number: String)
const names = ["fireball", "scorched_earth", "freeze", "heal"]
var assigned_spell: String
@export var index: int = 0

func _ready() -> void:
	$Button.connect("button_down", spell_clicked)
	assigned_spell = names[index]
	
func spell_clicked():
	emit_signal("clicked", assigned_spell)
	#emit_signal("clicked", self.name)
