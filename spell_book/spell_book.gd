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
	
	var spells: Array[Spell] = []
	for sn in SBookSpell.names:
		if (sn != ""):
			spells.append(Player.all_spells[sn].new())
	
	$Control/spell1/sp_name.text = spells[0].spell_name
	$Control/spell1/sp_desc.text = spells[0].description
	
	$Control/spell2/sp_name.text = spells[1].spell_name
	$Control/spell2/sp_desc.text = spells[1].description
	
	if len(spells) > 2:	
		$Control/spell3/sp_name.text = spells[2].spell_name
		$Control/spell3/sp_desc.text = spells[2].description
	else:
		$Control/spell3.hide()

	if len(spells) > 3:	
		$Control/spell4/sp_name.text = spells[3].spell_name
		$Control/spell4/sp_desc.text = spells[3].description
	else:
		$Control/spell4.hide()

	if len(spells) > 4:	
		$Control/spell5/sp_name.text = spells[4].spell_name
		$Control/spell5/sp_desc.text = spells[4].description
	else:
		$Control/spell5.hide()
		
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
		
