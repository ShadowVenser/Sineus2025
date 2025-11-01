extends Node2D

@onready var choose_action_screen = $choose_action
@onready var player = $choose_action/mage
@onready var enemy = $choose_action/new_enemy
@onready var defeated_enemy_label = $choose_action/defeated_enemy_label

@onready var spells_animations = $choose_action/spells_animations
@onready var secondary_animations = $choose_action/secondary_animations
@onready var enemy_death_animation = $choose_action/enemy_death
@onready var death_screen = $choose_action/death_screen
@onready var victory_screen = $choose_action/next_enemy
	
var rythm = WorldRythm.new()
var turn_number: int = 0
var defeated_enemies: int = 0
var wait_time: float = 0
var player_turn: bool = true
var choosing_class: bool = true
var choosing_weapon: bool = false
var victory_flag: bool = false
var victory_flag2: bool = false
var defeated_enemy_flag: bool = false
var defeated_enemy_flag2: bool = false
var defeated_enemy_flag3: bool = false
var defeated_hero_flag: bool = false
var defeated_hero_flag2: bool = false
var applying_spells_flag: bool = false
var applying_spells_flag2: bool = false
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
	
	player.player_is_dead.connect(self.player_death)
	enemy.enemy_is_dead.connect(self.enemy_defeated) 
	
	spells_animations.connect("animation_finished", stop_animation)
	enemy_death_animation.connect("animation_finished", stop_enemy_death_animation)
	spells_animations.hide()
	secondary_animations.hide()
	enemy_death_animation.hide()
	defeated_enemy_label.hide()
	death_screen.hide()
	death_screen.get_child(0).connect("button_down", go_to_main_menu)
	death_screen.get_child(1).connect("button_down", retry)
	victory_screen.hide()
	victory_screen.get_child(0).connect("button_down", go_to_main_menu)
	victory_screen.get_child(1).connect("button_down", new_cycle)
	enemy.new_enemy()
	player.enemy = enemy
	choose_action_screen.player = player
	player.rythm = rythm
	
func _process(delta: float) -> void:
	if choosing_action or defeated_enemy_flag3:
		return
	if wait_time > 0:
		wait_time -= delta
		return
	elif wait_time <= 0:
		if defeated_hero_flag:
			defeated_hero_flag2 = true
			player_death2()
			return
		if applying_spells_flag:
			var spell_name = rythm.get_next_casted()
			play_animation(spell_name)
			applying_spells_flag = rythm.apply_tick_spell()
			print("applyed spell")
			if applying_spells_flag:
				set_wait_time(2.0)
			else:
				set_wait_time(1.1)
			return
		if defeated_enemy_flag:
			defeated_enemy_flag = false
			enemy_defeated2()
			return
		if defeated_enemy_flag2:
			defeated_enemy_flag2 = false
			enemy_defeated3()
			return
		if player_turn:
			turn_number += 1
			print("Turn ", turn_number)
			SBookSpell.names = player.get_current_spells()
			player.set_dementia_spell()
			print(SBookSpell.names)
			choosing_action = true
			choose_action_screen.change_visibity(true)
		else:
			if applying_spells_flag2 == false:
				if rythm.next_tick():
					applying_spells_flag = true
					applying_spells_flag2 = true
					print("hohohehe")
					return
			if not defeated_enemy_flag:
				print("Enemy attacks!")
				enemy.attack()
			player_turn = true
			applying_spells_flag2 = false
		set_wait_time(0.6)
		
func action_pressed():
	player_turn = false
	choosing_action = false
	choose_action_screen.change_visibity(false)
	
func player_death():
	defeated_hero_flag = true
	spells_animations.show()
	play_animation("Death nova")
	player.hide()
	call_deferred("set_wait_time", 3.0)
	
func player_death2():
	defeated_hero_flag = true
	player.hide()
	enemy.hide()
	death_screen.show()
	
func enemy_defeated():
	player_turn = true
	$choose_action/SpellBook.change_size()
	player.add_spell()
	call_deferred("set_wait_time", 1.0)
	defeated_enemy_flag = true
	
func enemy_defeated2():
	enemy_death_animation.show()
	enemy_death_animation.play("death")
	call_deferred("set_wait_time", 2.0)
	enemy.hide()
	defeated_enemy_flag2 = true
	
func enemy_defeated3():
	defeated_enemy_flag3 = true
	victory_screen.show()
	
func new_cycle():
	victory_screen.hide()
	defeated_enemy_flag3 = false
	#defeated_enemy_label.hide()
	turn_number = 0
	enemy.new_enemy()
	enemy.show()
	applying_spells_flag2 = false
	
func play_animation(spell_name: String):
	print("SPELL NAME: ", spell_name)
	var animation_stats = spells_animations.spells[spell_name]
	spells_animations.position = animation_stats[0]
	spells_animations.scale = animation_stats[1]
	if animation_stats[2]:
		secondary_animations.show()
		secondary_animations.play(spell_name)
	spells_animations.show()
	spells_animations.play(spell_name)
	
func stop_animation():
	spells_animations.hide()
	secondary_animations.hide()
	
func stop_enemy_death_animation():
	enemy_death_animation.hide()
	
func go_to_main_menu():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	
func retry():
	get_tree().reload_current_scene()
		
func set_wait_time(time: float):
	wait_time = time
