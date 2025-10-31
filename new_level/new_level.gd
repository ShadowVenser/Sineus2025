extends Node2D

@onready var choose_action_screen = $choose_action
@onready var player = $mage
@onready var enemy = $new_enemy
	
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

var choosing_action: bool = false

func _ready() -> void:
	randomize()
	choose_action_screen.connect("action_pressed_for_level", self.action_pressed)  # Нажатие любой кнпоки вызывает здесь функцию дейсвтия
	choose_action_screen.connect("attack", player.attack) # Нажатие кнопки атаки вызывает метод атаки у героя
	choose_action_screen.connect("block", player.block) #...
	choose_action_screen.connect("cast_spell_on_enemy", player.cast_spell) # Вызывается функция каста у героя с именем закла
	
	enemy.deal_damage.connect(player.take_damage) #Нанесение урона врагом вызывает метод получения урона у героя 
	player.deal_damage.connect(enemy.take_damage) #Нанесение урона героем вызывает метод получения урона у врага 
	
func _process(delta: float) -> void:
	if choosing_action:
		return
	if wait_time > 0:
		wait_time -= delta
		return
	elif wait_time <= 0:
		turn_number += 1
		print("Turn ", turn_number)
		if player_turn:
			choosing_action = true
			choose_action_screen.change_visibity(true)
		else:
			print("Enemy attacks!")
			enemy.attack()
			player_turn = true		
		set_wait_time(2.0)
		
func action_pressed():
	player_turn = false
	choosing_action = false
	choose_action_screen.change_visibity(false)
		
func set_wait_time(time: float):
	wait_time = time
