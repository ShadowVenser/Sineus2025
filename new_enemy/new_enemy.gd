extends Node2D
#class_name entity

signal deal_damage(_damage: int)
signal enemy_is_dead()

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

var health: int = 10
var max_health: int = 10
var base_melee_damage: int = 3
var turn_counter: int = 0
var damage_type: String = ""
var effects: Effect

func _ready() -> void:
	health_label.text = "%d / %d" % [health, max_health]

func attack():
	var damage = (base_melee_damage - effects.get_weak_mod()) * effects.get_stun_mod()
	effects.effect_applied()
	emit_signal("deal_damage", damage)
	
func take_damage(damage: int, effect :String = ""):
	print(damage)
	if (effect != ""):
		print(effect)
		effects.add_effect(effect)
	health -= damage + effects.get_burn_mod()
	print("Enemy takes damage ", damage)
	health_label.text = "%d / %d" % [health, max_health]
	damage_number_animation.play("moving_number")
	damage_label.text = "-" + str(damage)
	if health <= 0:
		print("Enemy is dead")
		emit_signal("enemy_is_dead")
	
func change_visibility(flag: bool):
	health_label.visible = flag
	name_label.visible = flag
	
func new_enemy():
	print("NEW ENEMY")
	health = max_health
	health_label.text = "%d / %d" % [health, max_health]
