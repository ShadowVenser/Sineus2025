extends Control
class_name SBookSpell

signal clicked(spell_number: String)
static var names = ["", "", "", "", ""]
var assigned_spell: String = "exit"
@export var index: int = 0

func _ready() -> void:
	$Button.connect("button_down", spell_clicked)

func spell_clicked():
	if self.name == "exit":
		emit_signal("clicked", "exit")
	else:
		assigned_spell = names[index]
		emit_signal("clicked", assigned_spell)
	
	
