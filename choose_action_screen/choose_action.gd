extends CanvasLayer

signal action_pressed_for_level()
signal attack()
signal block()
signal cast_spell(action_name: String, spell_name: String)
signal cast_spell_on_enemy(spell_name: String)

@onready var book = $SpellBook
var player: Player

func _ready() -> void:
	$Control/melee_attack.connect("button_with_name", action_pressed) # Отправляем сигнал атаки уровню
	$Control/block.connect("button_with_name", action_pressed) # Отправляем сигнал блока уровню
	$Control/open_book.connect("button_down", spell_book_pressed)
	self.connect("cast_spell", action_pressed)
	book.connect("clicked", spell_clicked)
	book.visible = false

func _process(delta: float) -> void:
	pass
	
func attack_pressed():
	emit_signal("attack")
	
func block_pressed():
	emit_signal("block")
	
func spell_book_pressed():
	$Control.hide()
	$mage.hide()
	$new_enemy.hide()
	if (Player.all_dementia_spells.has(SBookSpell.names[-1])):
		SBookSpell.names.pop_back()
	var spells: Array[Spell] = []
	
	for sn in SBookSpell.names:
		if (sn != ""):
			spells.append(Player.all_spells[sn].new())
	print(spells[0].spell_name+" "+spells[0].description)
	$SpellBook/Control/spell1/sp_name.text = spells[0].spell_name
	$SpellBook/Control/spell1/sp_desc.text = spells[0].description
	if spells[0].type == 1:
		$SpellBook/Control/spell1/Paper.modulate = Color(0.265, 0.772, 0.947, 1.0)
	else:
		$SpellBook/Control/spell1/Paper.modulate = Color(1, 0.6, 0.6)
	
	if len(spells) > 1:	
		$SpellBook/Control/spell2/sp_name.text = spells[1].spell_name
		$SpellBook/Control/spell2/sp_desc.text = spells[1].description
		if spells[1].type == 1:
			$SpellBook/Control/spell2/Paper.modulate = Color(0.265, 0.772, 0.947, 1.0)
		else:
			$SpellBook/Control/spell2/Paper.modulate = Color(1, 0.6, 0.6)
		$SpellBook/Control/spell2.show()
	else:
		$SpellBook/Control/spell2.hide()
	
	if len(spells) > 2:	
		$SpellBook/Control/spell3/sp_name.text = spells[2].spell_name
		$SpellBook/Control/spell3/sp_desc.text = spells[2].description
		if spells[2].type == 1:
			$SpellBook/Control/spell3/Paper.modulate = Color(0.265, 0.772, 0.947, 1.0)
		else:
			$SpellBook/Control/spell3/Paper.modulate = Color(1, 0.6, 0.6)
		$SpellBook/Control/spell3.show()
	else:
		$SpellBook/Control/spell3.hide()

	if len(spells) > 3:	
		$SpellBook/Control/spell4/sp_name.text = spells[3].spell_name
		$SpellBook/Control/spell4/sp_desc.text = spells[3].description
		if spells[3].type == 1:
			$SpellBook/Control/spell4/Paper.modulate = Color(0.265, 0.772, 0.947, 1.0)
		else:
			$SpellBook/Control/spell4/Paper.modulate = Color(1, 0.6, 0.6)
		$SpellBook/Control/spell4.show()
	else:
		$SpellBook/Control/spell4.hide()

	var d_spell_info = player.get_dementia_spell()
	print(d_spell_info)
	if d_spell_info[0] != "":
		SBookSpell.names.append(d_spell_info[0])
		$SpellBook/Control/spell5/sp_name.text = d_spell_info[1]
		$SpellBook/Control/spell5/sp_desc.text = d_spell_info[2]
		$SpellBook/Control/spell5.show()
	else:
		$SpellBook/Control/spell5.hide()
	book.show()
	
func action_pressed(action_name: String, spell_name: String = ""):
	emit_signal("action_pressed_for_level")
	if action_name == "melee_attack":
		emit_signal("attack")
	elif action_name == "block":
		emit_signal("block")
	elif action_name == "spell":
		emit_signal("cast_spell_on_enemy", spell_name)
	
func spell_clicked(spell_name:String):
	if spell_name == "exit":
		return_to_actions()
	else:
		book.hide()
		emit_signal("cast_spell", "spell", spell_name)
		
func return_to_actions():
	$Control.show()
	$mage.show()
	$new_enemy.show()
	book.hide()
	
func change_visibity(flag: bool):
	if flag:
		$Control.show()
		$mage.show()
		$new_enemy.show()
		#$SpellBook.show()
	else:
		$Control.hide()
		$mage.show()
		$new_enemy.show()
		#$SpellBook.hide()
