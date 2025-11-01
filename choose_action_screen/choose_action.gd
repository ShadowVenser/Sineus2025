extends CanvasLayer

signal action_pressed_for_level()
signal attack()
signal block()
signal cast_spell(action_name: String, spell_name: String)
signal cast_spell_on_enemy(spell_name: String)

@onready var book = $SpellBook

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
	self.hide()
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
	self.show()
	book.hide()
	
func change_visibity(flag: bool):
	if flag:
		$Control.show()
		#$SpellBook.show()
	else:
		$Control.hide()
		#$SpellBook.hide()
