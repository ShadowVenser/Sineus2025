extends Node2D

@onready var choose_action_screen = $choose_action
@onready var player = $choose_action/mage
@onready var enemy = $choose_action/new_enemy
@onready var defeated_enemy_label = $choose_action/defeated_enemy_label

@onready var spells_animations = $choose_action/spells_animations
@onready var secondary_animations = $choose_action/secondary_animations
@onready var enemy_death_animation = $choose_action/enemy_death
	
var rythm = WorldRythm.new()
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
var defeated_enemy_flag2: bool = false
var defeated_hero_flag: bool = false
var defeated_hero_flag2: bool = false
var applying_spells_flag: bool = false
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
	
	player.enemy = $choose_action/new_enemy
	choose_action_screen.player = player
	player.rythm = rythm
	
func _process(delta: float) -> void:
	if choosing_action:
		return
	if wait_time > 0:
		wait_time -= delta
		return
	elif wait_time <= 0:
		if applying_spells_flag:
			var spell_name = rythm.get_next_casted()
			play_animation(spell_name)
			applying_spells_flag = rythm.apply_tick_spell()
			print("applyed spell")
			if applying_spells_flag:
				set_wait_time(2.0)
			else:
				set_wait_time(1.0)
			return
		if defeated_enemy_flag:
			defeated_enemy_flag = false
			enemy_defeated2()
			return
		if defeated_enemy_flag2:
			defeated_enemy_flag2 = false
			new_cycle()
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
			print("Enemy attacks!")
			enemy.attack()
			player_turn = true
			if rythm.next_tick():
				applying_spells_flag = true
				print("hohohehe")
				return
		set_wait_time(0.6)
		
func action_pressed():
	player_turn = false
	choosing_action = false
	choose_action_screen.change_visibity(false)
	
func player_death():
	pass
	
func enemy_defeated():
	player_turn = true
	$choose_action/SpellBook.change_size()
	call_deferred("set_wait_time", 2.0)
	defeated_enemy_flag = true
	
func enemy_defeated2():
	enemy_death_animation.show()
	enemy_death_animation.play("death")
	call_deferred("set_wait_time", 5.0)
	enemy.hide()
	defeated_enemy_flag2 = true
	defeated_enemy_label.show()
	
func new_cycle():
	defeated_enemy_label.hide()
	turn_number = 0
	enemy.new_enemy()
	enemy.show()
	
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
	print("HIDE")
	spells_animations.hide()
	secondary_animations.hide()
	
func stop_enemy_death_animation():
	enemy_death_animation.hide()
		
func set_wait_time(time: float):
	wait_time = time
