extends Node2D

@onready var player = $player
@onready var enemy = $enemy
@onready var lvlup_screen = $character_creator
@onready var lvlup_label = $character_creator/RichTextLabel
@onready var loot_screen = $loot_offer
@onready var loot_lable = $loot_offer/Label
@onready var battle_begins_label = $CanvasLayer/battle_begins
@onready var death_label = $CanvasLayer/death_panel
@onready var victory_screen = $victory_screen
@onready var victory_label = $CanvasLayer/victory_panel

var turn_number: int = 0
var defeated_enemies: int = 0
var wait_time: float = 0
var player_turn: bool = true
var choosing_class: bool = true
var choosing_weapon: bool = false
var victory_flag: bool = false
var victory_flag2: bool = false
var battle_begins_flag: bool = false
var defeated_enemy_flag: bool = false
var defeated_hero_flag: bool = false
var defeated_hero_flag2: bool = false
var loot: String

func _ready() -> void:
	randomize()
	lvlup_screen.hide()
	loot_screen.hide()
	victory_screen.hide()
	battle_begins_label.hide()
	death_label.hide()
	victory_label.hide()
	for button in $character_creator/Control.get_children():
		button.button_with_name.connect(player.lvlup)
		button.button_down.connect(self.stop_showing_lvlup_screen)
	for button in $loot_offer/Control.get_children():
		button.button_with_name.connect(self.stop_showing_loot_screen)
	for button in $victory_screen/Control.get_children():
		button.button_with_name.connect(self.victory_button)
	enemy.deal_damage.connect(player.take_damage)
	enemy.new_opponent_stats.connect(player.get_stats)
	enemy.entity_is_dead.connect(self.enemy_defeated)
	player.new_opponent_stats.connect(enemy.get_stats)
	player.deal_damage.connect(enemy.take_damage)
	player.entity_is_dead.connect(self.death)
	player.create_character()
	level_up()
	enemy.new_enemy()
	
func _process(delta: float) -> void:
	if choosing_class or choosing_weapon or victory_flag2:
		return
	if wait_time > 0:
		wait_time -= delta
		return
	elif wait_time <= 0:
		if defeated_enemy_flag:
			defeated_enemy_flag = false
			new_cycle()
			return
		elif defeated_hero_flag:
			defeated_hero_flag = false
			death2()
			return
		elif defeated_hero_flag2:
			defeated_hero_flag2 = false
			death_label.hide()
			new_hero()
			return
		elif battle_begins_flag:
			battle_begins_flag = false
			battle_begins_label.hide()
			return
		elif victory_flag:
			victory_flag = false
			victory_flag2 = true
			victory_screen.show()
			return
	
	turn_number += 1
	#print("Turn ", turn_number)
	if player_turn:
		#print("Player attacks!")
		player.attack()
		player_turn = false
	else:
		#print("Enemy attacks!")
		enemy.attack()
		player_turn = true		
	set_wait_time(0.7)

func enemy_defeated(_loot: String):
	call_deferred("set_wait_time", 2.0)
	#print("ENEMY IS DEFEATED!")
	loot = _loot
	defeated_enemy_flag = true
	
func new_cycle():
	player.change_visibility(false)
	turn_number = 0
	defeated_enemies += 1
	if defeated_enemies == 5:
		victory()
		return
	player.heal()
	choosing_weapon = true
	if player.player_lvl_int < 3:
		lvlup_label.text = "ВРАГ ПОБЕЖДЕН!\nПОВЫСЬТЕ УРОВЕНЬ ПЕРСОНАЖА"
		level_up()
	else:
		new_loot()
	enemy.new_enemy()
	
func death(_loot: String):
	call_deferred("set_wait_time", 2.0)
	#print("HERO IS DEAD! \n *****************************************")
	defeated_hero_flag = true
	
func death2():
	enemy.change_visibility(false)
	death_label.show()
	call_deferred("set_wait_time", 5.0)
	defeated_hero_flag2 = true

func new_hero():
	enemy.change_visibility(false)
	player.create_character()
	lvlup_label.text = "ВЫБЕРИТЕ КЛАСС ПЕРСОНАЖА"
	level_up()
	enemy.new_enemy()
	turn_number = 0
	defeated_enemies = 0

func level_up():
	set_abilities_for_lvlup()
	lvlup_screen.show()
	choosing_class = true

func stop_showing_lvlup_screen():
	lvlup_screen.hide()
	choosing_class = false
	if choosing_weapon:
		new_loot()
	else:
		enemy.change_visibility(true)
		player.change_visibility(true)
		begin_battle()
	
func new_loot():
	var prev_weapon = player.weapon
	var new_weapon = player.weapons[loot]
	var prev_weapon_name = match_weapon_names(prev_weapon["name"])
	var prev_weapon_type = match_weapon_types(prev_weapon["damage_type"])
	var new_weapon_name = match_weapon_names(new_weapon["name"])
	var new_weapon_type = match_weapon_types(new_weapon["damage_type"])
	loot_lable.text = "ВЗЯТЬ НОВОЕ ОРУЖИЕ?\n\nТекущее оружие: %s \nУрон: %d | Тип урона: %s
	\nВыпавшее оружие: %s \nУрон: %d | Тип урона: %s" % [prev_weapon_name, prev_weapon["damage"], prev_weapon_type, 
	new_weapon_name, new_weapon["damage"], new_weapon_type]
	loot_screen.show()
	
func stop_showing_loot_screen(_button_name: String):
	loot_screen.hide()
	choosing_weapon = false
	if _button_name == "yes":
		player.new_weapon(loot)
	enemy.change_visibility(true)
	player.change_visibility(true)
	begin_battle()
	
func begin_battle():
	var battle_begins_text: String
	player.calc_base_damage()
	enemy.calc_base_damage()
	player.calc_base_defence()
	enemy.calc_base_defence()
	battle_begins_flag = true
	match defeated_enemies:
		0: battle_begins_text = "Первый бой!"
		1: battle_begins_text = "Второй бой!"
		2: battle_begins_text = "Третий бой!"
		3: battle_begins_text = "Четвертый бой!"
		4: battle_begins_text = "Финальный бой!"
	if player.stats["agility"] < enemy.enemy["agility"]:
		player_turn = false
		battle_begins_text += "\nПервым атакует монстр"
	else:
		player_turn = true
		battle_begins_text += "\nПервым атакует герой"	
	battle_begins_label.text = battle_begins_text
	battle_begins_label.show()
	set_wait_time(2.0)
	
func victory():
	#print("VICTORY!")
	victory_flag = true
	defeated_enemy_flag = false
	victory_label.show()
	set_wait_time(2.0)
	
func victory_button(_button_name: String):
	if _button_name == "yes":
		get_tree().reload_current_scene()
	else:
		get_tree().quit()

func set_wait_time(time: float):
	wait_time = time
	
func set_abilities_for_lvlup():
	var stats_and_abilities: String
	var ability_text: String = ""
	stats_and_abilities = "Характеристики героя:\nСила: %d | Ловкость: %d | Выносливость: %d" % [player.stats["strength"], player.stats["agility"], player.stats["endurance"]]
	stats_and_abilities += "\n\nСпособности героя:\n"
	for ability in player.abilities.keys():
		if player.abilities[ability]:
			match ability:
				"stealth": ability_text = "Скрытая атака | "
				"poison": ability_text = "Яд | "
				"impulse": ability_text = "Порыв к действию | "
				"shield": ability_text = "Щит | "
				"rage": ability_text = "Ярость | "
				"stone": ability_text = "Каменная кожа | "
				_: ability_text = ""
			stats_and_abilities += ability_text
	if ability_text == "":
		stats_and_abilities += "Нет способностей"
	else:
		stats_and_abilities = stats_and_abilities.substr(0, stats_and_abilities.length() - 2)
	$character_creator/stats_and_abilities.text = stats_and_abilities
	
	var rogue_button_text: String
	match player.player_level["rogue"]:
		0: rogue_button_text = "Скрытая атака:\n+1 к урону если ловкость героя выше вражеской"
		1: rogue_button_text = "+1 к ловкости"
		2: rogue_button_text = "Яд:\nУрон увеличивается на 1 за каждую атаку по врагу"
	$character_creator/Control/rogue/ability.text = rogue_button_text
	
	var warrior_button_text: String
	match player.player_level["warrior"]:
		0: warrior_button_text = "Порыв к действию:\nВ первый ход наносит двойной урон оружием"
		1: warrior_button_text = "Щит:\n-3 к получаемому урону если сила героя выше вражеской"
		2: warrior_button_text = "+1 к силе"
	$character_creator/Control/warrior/ability.text = warrior_button_text
	
	var barb_button_text: String
	match player.player_level["barbarian"]:
		0: barb_button_text = "Ярость:\n+2 к урону в первые три хода, затем -1 к урону"
		1: barb_button_text = "Каменная кожа:\nПолучаемый урон снижается на значение вынослиовсти"
		2: barb_button_text = "+1 к вынослиовсти"
	$character_creator/Control/barbarian/ability.text = barb_button_text
	
func match_weapon_names(old_name: String) -> String:
	match old_name:
		"sword": return "Меч"
		"club": return "Дубина"
		"dagger": return "Кинжал"
		"axe": return "Топор"
		"spear": return "Копье"
		"legendary_sword": return "Легендарный меч"
		_: return ""
		
func match_weapon_types(old_type: String) -> String:
	match old_type:
		"blunt": return "Дробящий"
		"sever": return "Рубящий"
		"pierce": return "Колющий"
		_: return ""
