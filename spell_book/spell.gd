extends Control
class_name SBookSpell

signal clicked(spell_number: String)
static var names = ["fireball", "scorched_earth", "freeze", "", ""]
var assigned_spell: String
@export var index: int = 0

func _ready() -> void:
	$Button.connect("button_down", spell_clicked)
	assigned_spell = names[index]
	

func spell_clicked():
	if self.name == "exit":
		emit_signal("clicked", "exit")
	else:
		emit_signal("clicked", assigned_spell)
	
