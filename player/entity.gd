extends Node2D
class_name entity

signal deal_damage(_damage: int, _weapon_damage: int, _damage_type: String)
signal new_opponent_stats(_stats: Dictionary)
signal entity_is_dead(_loot: String)

@onready var name_label = $Control/label
@onready var health_label = $Control/health_label
@onready var damage_animation = $swing_animation
@onready var damage_position = $damage_pos
@onready var death_animation = $death_animation
@onready var damage_label = $Control/damage_lable
@onready var damage_number_animation = $Control/damage_lable/AnimationPlayer
@onready var clash_sound = $AudioStreamPlayer2D

const sound_cash = [preload("res://sfx/sword-clash-241729.mp3"), preload("res://sfx/sword-clashhit-393837.mp3"), 
preload("res://sfx/sword-slice-2-393845.mp3"), preload("res://sfx/sword-slice-393847.mp3")]

var health: int
var max_health: int
var turn_counter: int = 0
var base_damage: int = 0
var base_defence: int = 0
var weapon_damage: int = 0
var damage_type: String = ""
var loot: String = ""
var abilities: Dictionary = {"stealth": false, "poison": false, "impulse": false, "shield": false, "rage": false, "stone": false, 
"blunt_weakness": false, "sever_resist": false, "fire_breath": false}
var stats: Dictionary = {"strength": 0, "agility": 0, "endurance": 0}
var opponent_stats: Dictionary

func _ready() -> void:
	damage_animation.animation_finished.connect(stop_animation)
	damage_animation.hide()
	death_animation.animation_finished.connect(stop_death_animation)
	death_animation.hide()
	self.change_visibility(false)

func attack():
	turn_counter += 1
	var attack_chance = randi_range(1, stats["agility"] + opponent_stats["agility"])
	if attack_chance <= opponent_stats["agility"]:
		#print(" -- ",self.name," missed! (", attack_chance, ")")
		play_damage_animation()
		return
	var damage = base_damage
	#Подсчет начального урона и проверка на скрытую атаку проихсодит в calc_base_damage
	if abilities["impulse"] and turn_counter == 1:
		damage += weapon_damage
	if abilities["poison"]:
		damage = damage + turn_counter - 1
	if abilities["rage"]:
		if turn_counter <= 3:
			damage += 2
		else:
			damage -= 1
	if abilities["fire_breath"] and turn_counter % 3 == 0:
		damage += 3
	#print(attack_chance, " -> " , self.name," strikes! Damage = ", damage)
	play_damage_animation(true)
	emit_signal("deal_damage", damage, weapon_damage, damage_type)
	
func take_damage(damage: int, _weapon_damage: int, _damage_type: String):
	#Проверка на защитные способонсти просиходит в calc_base_defence, а также в take_damage в классе enemy
	damage -= base_defence
	if damage > 0:
		health -= damage
		damage_label.text = "-" + str(damage)
		damage_number_animation.play("moving_number")
	#print(self.name, " health = ", health)
	health_label.text = "%d / %d" % [health, max_health]
	if health <= 0:
		change_visibility(false)
		death_animation.show()
		death_animation.play("death")
		emit_signal("entity_is_dead", loot)

func get_stats(_stats: Dictionary):
	opponent_stats = _stats
	
func play_damage_animation(hit: bool = false):
	clash_sound.stream = sound_cash.pick_random()
	clash_sound.play()
	damage_animation.rotation_degrees = [0, 30, 45, 60, 75, 90].pick_random()
	damage_animation.position = damage_position.position
	if !hit:
		damage_animation.position += [Vector2(150, 150), Vector2(-150, -150), Vector2(-150, 150), Vector2(150, -150)].pick_random()
	damage_animation.show()
	damage_animation.play()
	
func stop_animation():
	damage_animation.hide()
	
func stop_death_animation():
	death_animation.hide()
	
func change_visibility(flag: bool):
	health_label.visible = flag
	name_label.visible = flag
	
func calc_base_damage():
	base_damage = 0
	if abilities["stealth"] and stats["agility"] > opponent_stats["agility"]:
		base_damage += 1
		
func calc_base_defence():
	base_defence = 0
	if abilities["shield"] and stats["strength"] > opponent_stats["strength"]:
		base_defence += 3
	if abilities["stone"]:
		base_defence += stats["endurance"]
	#print(self.name, " base defence = ", base_defence)
