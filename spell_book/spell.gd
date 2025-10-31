extends Control

signal clicked(spell_number: String)

func _ready() -> void:
	$Button.connect("button_down", spell_clicked)
	
func spell_clicked():
	emit_signal("clicked", self.name)
