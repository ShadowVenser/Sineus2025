extends CanvasLayer

signal clicked(label: String)

@onready var flow: FlowContainer = $Control/MarginContainer/ScrollContainer/ButtonsFlow

var items: Array[String] = ["One", "Two", "Exit"]
var size: int = 2

func _ready() -> void:
	$Control/spell1.connect("clicked", spell_clicked)
	$Control/spell2.connect("clicked", spell_clicked)
	$Control/spell3.connect("clicked", spell_clicked)
	$Control/spell4.connect("clicked", spell_clicked)
	$Control/spell5.connect("clicked", spell_clicked)
	$Control/exit.connect("clicked", spell_clicked)
	
	
		
	pass
		
func spell_clicked(spell_name: String):
	#print(spell_name," clicked")
	emit_signal("clicked", spell_name)
	
func change_size(plus: int = 1):
	size += plus
	if size >= 3:
		$Control/spell3.show()
	if size >= 4:
		$Control/spell4.show()
	if size >= 5:
		$Control/spell5.show()
		
