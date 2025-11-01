extends HBoxContainer
class_name RythmLine

var vboxes: Array[VBoxContainer] = []

func _ready():
	
	for x in range(3):
		var sprite = TextureRect.new()
		sprite.texture = load("uid://2gv0w847j6ba")
		sprite.size_flags_vertical = 0
		var vbox = VBoxContainer.new()
		vboxes.append(vbox)
		vbox.position = Vector2(11, 5)
		vbox.scale = Vector2(1.25, 1.25)
		add_child(sprite)
		sprite.add_child(vbox)
	
	for x in range(2):
		var sprite = TextureRect.new()
		sprite.texture = load("uid://bam4jewxatm5n")
		sprite.size_flags_vertical = 0
		add_child(sprite)
	#for row in timeline:
		#var vbox = VBoxContainer.new()
		#add_child(vbox)
		#for spell in row:
			#var sprite = TextureRect.new()
			#sprite.texture = load("uid://2gv0w847j6ba")  # загружаем изображение для заклинания
			#vbox.add_child(sprite)
		
#!!!!РАЗМЕР 3!!!!
func redraw(ticks: Array[RythmTick]) -> void:
	for i in range(3):
		for child in vboxes[i].get_children():
			vboxes[i].remove_child(child)
		for spell in ticks[i].spells:
			var sprite = TextureRect.new()
			if spell.type == 1:
				sprite.texture = load("uid://dfr3kr1p40odo")
			elif spell.type == -1:
				sprite.texture = load("uid://typsdrsr65eo")
			else:
				sprite.texture = load("uid://cqn0veul03y01")
			sprite.size_flags_vertical = 0
			sprite.size_flags_horizontal = 0
			vboxes[i].add_child(sprite)
			

func add_spell(spell: Spell, tick_diff: int) -> void:
	if tick_diff>2:
		return
	if tick_diff<0:
		return

	var sprite = TextureRect.new()
	if spell.type == 1:
		sprite.texture = load("uid://dfr3kr1p40odo")
	elif spell.type == -1:
		sprite.texture = load("uid://typsdrsr65eo")
	else:
		sprite.texture = load("uid://cqn0veul03y01")
	sprite.size_flags_vertical = 0
	sprite.size_flags_horizontal = 0
	vboxes[tick_diff].add_child(sprite)
